# 🚀 CrypTrend

Uma aplicação completa para análise de mercado de criptomoedas utilizando **Flutter + NestJS**, focada em estratégias baseadas em **indicadores técnicos**, **padrões de candles** e **assistência com IA em tempo real**.

O sistema permite que traders configurem estratégias personalizadas, monitorem sinais de compra e venda automaticamente e recebam notificações instantâneas diretamente no celular.

---

## 📸 Demonstração

<img src="/img/cryptrend.jpg" alt="img-cryptrend" style="width: 600px; height: 500px;">

---

# 📱 Visão Geral

O usuário pode:

- Selecionar uma criptomoeda
- Escolher indicadores técnicos
- Configurar gatilhos de compra e venda
- Monitorar múltiplos tempos gráficos
- Receber push notifications em tempo real
- Conversar com uma IA integrada ao mercado crypto
- Solicitar análises e orientações sobre trades

A aplicação foi construída com arquitetura moderna e escalável, separando claramente frontend mobile, backend e automações inteligentes via IA.

---

# ✨ Funcionalidades

## 📊 Estratégias Baseadas em Indicadores Técnicos

Criação de estratégias utilizando indicadores como:

- StochRSI
- Médias móveis
- Di+Di-
- Entre outros

O sistema identifica automaticamente quando os critérios definidos pelo usuário são atendidos.

---

## 🕯️ Detecção de Padrões de Candles

Suporte para análise de padrões gráficos, como:

- Hammer
- Engulfing
- Doji
- Morning Star
- Shooting Star
- Entre outros

Os padrões podem ser combinados com indicadores técnicos para gerar sinais mais precisos.

---

## ⏱️ Monitoramento Multi Timeframe

O app verifica em quais tempos gráficos ocorreram sinais de:

- 📈 Compra
- 📉 Venda

Exemplo:

- 1m
- 5m
- 15m
- 1h
- 4h
- 1d
- 1S

---

## 🔔 Push Notifications

Quando um gatilho configurado acontece, o usuário recebe uma notificação instantânea no dispositivo móvel.

Implementado utilizando:

- Firebase Cloud Messaging (FCM)

### Exemplo

```txt
BTC/USDT - RSI abaixo de 30 no gráfico de 15m
Possível oportunidade de compra 🚀
```

---

## 🤖 Assistente IA Integrado

A aplicação possui um chat inteligente integrado com:

- n8n
- MCP Client
- MCP Server (NestJS)

A IA funciona como um assistente para traders, permitindo:

- Consultar informações do mercado em tempo real
- Solicitar análises
- Tirar dúvidas sobre estratégias
- Receber orientações sobre trades
- Obter insights baseados em indicadores

---

# 🛠️ Tecnologias Utilizadas

## 📱 Mobile

- Dart
- Flutter
- Firebase
- Firebase Cloud Messaging (FCM)

---

## ⚙️ Backend

- TypeScript
- Node.js
- NestJS
- Prisma ORM
- PostgreSQL

---

## 🤖 Automação & IA

- n8n
- MCP Protocol
- MCP Client
- MCP Server

---

# 🔥 Objetivo do Projeto

O objetivo deste projeto é fornecer uma plataforma inteligente para auxiliar traders no mercado de criptomoedas através de:

- Automação de estratégias
- Alertas em tempo real
- Análise técnica
- Assistência com IA
- Integração entre múltiplos serviços

# 🚀 Como Executar

---

## Mobile

```bash
flutter pub get

flutter run
```

## n8n

Configure os workflows do n8n para comunicação com o MCP Server.
