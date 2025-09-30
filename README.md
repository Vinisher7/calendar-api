# Calendar API

Uma API RESTful robusta para gerenciamento de reservas e agendamentos, construída com Ruby on Rails, oferecendo autenticação JWT, notificações em tempo real via WebSockets e arquitetura orientada a serviços.

## Índice

- [Visão Geral](#visão-geral)
- [Tecnologias](#tecnologias)
- [Pré-requisitos](#pré-requisitos)
- [Instalação](#instalação)
- [Configuração](#configuração)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [API Endpoints](#api-endpoints)
- [Autenticação](#autenticação)
- [WebSockets](#websockets)
- [Testes](#testes)
- [Deploy](#deploy)
- [Contribuindo](#contribuindo)

## Visão Geral

O **Calendar API** é uma solução backend completa para sistemas de agendamento e reservas, projetada para fornecer uma base sólida e escalável para aplicações de calendário interativo. A API implementa padrões modernos de desenvolvimento, incluindo autenticação JWT stateless, notificações em tempo real e arquitetura baseada em interactors.

### Principais Funcionalidades

- **Autenticação JWT** - Sistema seguro de autenticação stateless
- **Gestão de Reservas** - CRUD completo com validações de negócio
- **Sistema de Observações** - Registro de notas e observações por data
- **Notificações Real-time** - WebSockets via Action Cable
- **Sistema de Pagamentos** - Gestão financeira integrada (em desenvolvimento)
- **Arquitetura Limpa** - Padrão Interactor para organização da lógica de negócio

## Tecnologias

### Core

- **Ruby** 3.2.8
- **Rails** 7.1.3
- **SQLite3** - Banco de dados

### Autenticação & Segurança

- **Devise** 4.9 - Sistema de autenticação
- **Devise-JWT** 0.12.1 - Tokens JWT
- **Rack-CORS** - Configuração de CORS

### Arquitetura & Padrões

- **Interactor** 3.0 - Service objects pattern
- **JSONAPI Serializer** - Serialização padronizada

### Desenvolvimento & Testes

- **RSpec Rails** 7.0.0 - Framework de testes
- **Debug** - Ferramenta de debugging
- **Bootsnap** - Otimização de boot time

## Pré-requisitos

Antes de iniciar, certifique-se de ter instalado:

- Ruby 3.2.8
- Rails 7.1.3+
- Bundler 2.0+
- SQLite3
- Git

## Instalação

### 1. Clone o repositório

```bash
git clone https://github.com/seu-usuario/calendar-api.git
cd calendar-api
```

### 2. Instale as dependências

```bash
bundle install
```

### 3. Configure o banco de dados

```bash
# Cria o banco de dados
rails db:create

# Executa as migrations
rails db:migrate

# (Opcional) Popula com dados de exemplo
rails db:seed
```

### 4. Configure as variáveis de ambiente

```bash
# Edite as credenciais
rails credentials:edit
```

Adicione sua secret_key_base:

```yaml
secret_key_base: seu_secret_key_aqui
```

### 5. Inicie o servidor

```bash
rails server
```

A API estará disponível em `http://localhost:3000`

## Configuração

### Configuração de CORS

O CORS está configurado em `config/initializers/cors.rb`. Ajuste as origens permitidas conforme necessário:

```ruby
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins 'http://localhost:3001' # Adicione suas origens aqui
    resource '*',
      headers: :any,
      methods: [:get, :post, :put, :patch, :delete, :options, :head],
      expose: ['Authorization']
  end
end
```

## Estrutura do Projeto

```
app/
├── channels/           # WebSocket channels (Action Cable)
│   └── notifications_channel.rb
├── controllers/
│   ├── api/v1/        # Controllers versionados
│   │   ├── health_controller.rb
│   │   ├── observations_controller.rb
│   │   ├── payments_controller.rb
│   │   └── reservations_controller.rb
│   └── users/         # Controllers de autenticação
│       ├── registrations_controller.rb
│       └── sessions_controller.rb
├── interactors/       # Lógica de negócio
│   ├── notifications/
│   ├── observations/
│   ├── organizers/    # Composição de interactors
│   └── reservations/
├── models/            # Models ActiveRecord
│   ├── notification.rb
│   ├── observation.rb
│   ├── payment.rb
│   ├── reservation.rb
│   └── user.rb
└── serializers/       # Serializers JSONAPI
    └── user_serializer.rb
```

## API Endpoints

### Health Check

```http
GET /api/v1/health
```

### Autenticação

#### Registro

```http
POST /signup
Content-Type: application/json

{
  "user": {
    "email": "user@example.com",
    "password": "password123"
  }
}
```

#### Login

```http
POST /login
Content-Type: application/json

{
  "user": {
    "email": "user@example.com",
    "password": "password123"
  }
}
```

#### Logout

```http
DELETE /logout
Authorization: Bearer {token}
```

### Reservas

#### Listar Reservas

```http
GET /api/v1/reservations
Authorization: Bearer {token}
```

#### Criar Reserva

```http
POST /api/v1/reservations
Authorization: Bearer {token}
Content-Type: application/json

{
  "customer_name": "João Silva",
  "total_amount_cents": 10000,
  "signal_amount_cents": 3000,
  "entry_date_time": "2025-08-20 14:00:00",
  "out_date_time": "2025-08-22 12:00:00",
  "observation": "Cliente VIP",
  "payment_status": "pending"
}
```

### Observações

#### Listar Observações

```http
GET /api/v1/observations
Authorization: Bearer {token}
```

#### Criar Observação

```http
POST /api/v1/observations
Authorization: Bearer {token}
Content-Type: application/json

{
  "observation": {
    "description": "Reunião importante agendada",
    "date": "2025-08-15"
  }
}
```

## Autenticação

A API utiliza autenticação baseada em JWT (JSON Web Tokens). Após o login bem-sucedido, o token deve ser incluído no header de todas as requisições autenticadas:

```http
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...
```

### Fluxo de Autenticação

1. Cliente faz login com email/senha
2. API valida credenciais e retorna JWT
3. Cliente armazena token de forma segura
4. Cliente inclui token em todas as requisições subsequentes
5. API valida token e processa requisição

## WebSockets

A API implementa notificações em tempo real através do Action Cable:

### Conectando ao Canal de Notificações

```javascript
// Exemplo de conexão WebSocket
const cable = ActionCable.createConsumer("ws://localhost:3000/cable");

const notificationChannel = cable.subscriptions.create(
  { channel: "NotificationsChannel" },
  {
    received(data) {
      console.log("Nova notificação:", data);
    },
  }
);
```

## Testes

O projeto utiliza RSpec para testes. Execute a suite completa com:

```bash
# Executar todos os testes
bundle exec rspec

# Executar testes específicos
bundle exec rspec spec/models/reservation_spec.rb

# Executar com coverage
bundle exec rspec --format documentation
```

### Estrutura de Testes

- `spec/models/` - Testes de models
- `spec/requests/` - Testes de integração da API
- `spec/interactors/` - Testes de lógica de negócio
- `spec/channels/` - Testes de WebSockets

## Deploy

### Deploy com Docker

```bash
# Build da imagem
docker build -t calendar-api .

# Executar container
docker run -p 3000:3000 calendar-api
```

### Variáveis de Ambiente para Produção

```env
RAILS_ENV=production
SECRET_KEY_BASE=sua_chave_secreta
DATABASE_URL=postgres://user:pass@host:5432/dbname
REDIS_URL=redis://localhost:6379/1
```

### Padrões de Código

- Siga o [Ruby Style Guide](https://rubystyle.guide)
- Mantenha cobertura de testes acima de 80%
- Use interactors para lógica de negócio complexa
- Documente endpoints novos ou alterados

---

**Desenvolvido com ❤️ usando Ruby on Rails**
