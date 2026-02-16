import 'package:cryptrend/components/chatInput/chatInput.dart';
import 'package:cryptrend/components/messagebubble/messagebubble.dart';
import 'package:cryptrend/core/message/MessageModel.dart';
import 'package:cryptrend/pages/agentSettings/agentSettings.dart';
import 'package:cryptrend/service/ChatService.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../agentSettings/agentSettings.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ScrollController _scrollController = ScrollController();
  final SupabaseClient supabase = Supabase.instance.client;

  List<MessageModel> messages = [];
  String? chatId;
  bool isLoading = false;
  RealtimeChannel? _channel;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    await _loadChatId();
    await _loadMessages();
    _setupRealtimeSubscription();
  }

  Future<void> _loadChatId() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      chatId = sharedPreferences.getString('chatId');
    });
  }

  Future<void> _loadMessages() async {
    if (chatId == null) return;

    try {
      final response = await supabase
          .from('ChatMessage')
          .select()
          .eq('chatId', chatId!)
          .order('createdAt', ascending: true);

      setState(() {
        messages = (response as List)
            .map((json) => MessageModel.fromJson(json))
            .toList();
      });

      _scrollToBottom();
    } catch (e) {
      print('Erro ao carregar mensagens: $e');
    }
  }

  void _setupRealtimeSubscription() {
    if (chatId == null) return;

    _channel = supabase
        .channel('messages_channel')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'ChatMessage',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'chatId',
            value: chatId,
          ),
          callback: (payload) {
            final newMessage = MessageModel.fromJson(payload.newRecord);
            setState(() {
              messages.add(newMessage);
            });
            _scrollToBottom();
          },
        )
        .subscribe();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _handleSendMessage(String message) async {
    if (message.isNotEmpty) {
      await ChatService.sendMessage(context, message);
    }

    _loadMessages();
  }

  Future<void> _clearChat() async {
    if (chatId == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Limpar conversa'),
        content: Text(
          'Tem certeza que deseja limpar todas as mensagens desta conversa?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Limpar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await supabase.from('ChatMessage').delete().eq('chatId', chatId!);

      setState(() {
        messages.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Conversa limpa com sucesso'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      print('Erro ao limpar conversa: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao limpar conversa'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _channel?.unsubscribe();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Icon(Icons.smart_toy, color: Colors.blue[700]),
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'IA',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'clear') {
                _clearChat();
              } else if (value == 'train') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AgentSettings()),
                );
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'train',
                child: Row(
                  children: [
                    Icon(Icons.model_training, color: Colors.blue),
                    SizedBox(width: 12),
                    Text('Treinar Agente'),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red),
                    SizedBox(width: 12),
                    Text('Limpar conversa'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Nenhuma mensagem ainda',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Envie uma mensagem para começar',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return MessageBubble(message: messages[index]);
                    },
                  ),
          ),
          ChatInput(onSendMessage: _handleSendMessage, isLoading: isLoading),
        ],
      ),
    );
  }
}
