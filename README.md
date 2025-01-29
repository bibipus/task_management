# Task Management Application

## Obsah
- [Popis projektu](#popis-projektu)
- [Použité technologie](#použité-technologie)
- [Instalace](#instalace)
- [Spuštění aplikace](#spuštění-aplikace)
- [Testování](#testování)
- [Seedy](#seedy)
- [Struktura modelů](#struktura-modelů)
- [Funkcionalita](#funkcionalita)
- [Další poznámky](#další-poznámky)

## Popis projektu

Tato aplikace slouží ke správě úkolů v projektech. Umožňuje uživatelům přihlašování, vytváření projektů, úkolů a tagů, správu svých dat a jejich filtrování. Aplikace využívá server-side rendering pomocí Ruby on Rails.

## Použité technologie

- **Ruby on Rails** (poslední stabilní verze)
- **PostgreSQL** (relační databáze)
- **ActiveRecord** (ORM v Rails)
- **Devise** (autentizace)
- **Simple Form** (generování formulářů)
- **Pagy** (paginace)
- **Bootstrap** (frontend framework)
- **RSpec** (testování)
- **FactoryBot** (vytváření testovacích dat)
- **Bullet** (kontrola N+1 dotazů)
- **Slim & ERB** (šablony pro zobrazení stránek)

## Instalace

Nejprve si připravte prostředí:

```sh
# Naklonování repozitáře
git clone https://github.com/bibipus/task_management.git
cd task-management-app

# Instalace závislostí
bundle install

# Nastavení databáze
rails db:create
rails db:migrate
```

## Spuštění aplikace

Aplikaci můžete spustit pomocí:

```sh
rails server
```

Aplikace bude dostupná na `http://localhost:3000/`

## Testování

Pro spuštění testů použijte:

```sh
rspec
```

## Seedy

Pro naplnění databáze testovacími daty spusťte:

```sh
rails db:seed
```

## Struktura modelů

Aplikace obsahuje následující modely:

- **User** – uživatelé spravují své projekty, úkoly a tagy
- **Project** – obsahuje úkoly, patří jednomu uživateli
- **Task** – úkoly patří projektu (nebo žádnému) a uživateli, mohou mít tagy
- **Tag** – může být přiřazen více úkolům, patří jednomu uživateli

Vztahy mezi modely:

- **User 1:N Project**
- **User 1:N Task**
- **User 1:N Tag**
- **Project 1:N Task**
- **Task M:N Tag** (realizováno přes `has_many :through`)

## Funkcionalita

### Autentizace a uživatelé
- Registrace, přihlášení a správa účtu přes Devise
- Každý uživatel vidí pouze své projekty, úkoly a tagy

### Správa projektů
- Vytváření, úprava a mazání projektů
- Při smazání projektu se smažou všechny úkoly

### Správa úkolů
- Vytváření, úprava a mazání úkolů
- Přiřazení úkolů k projektům a tagům
- Označení úkolu jako hotový/nehotový
- Možnost filtrování úkolů podle stavu
- Možnost vyhledávání v úkolech, projektech a tagách

### Správa tagů
- Vytváření a mazání tagů
- Při smazání tagu se neodstraní úkoly, pouze jejich vazba na daný tag

### Další funkce
- Paginace seznamů pomocí `Pagy`
- Podpora vyhledávání v názvech úkolů, projektů a tagů
- UI přeloženo do češtiny pomocí Rails I18n
- Použití Turbo pro optimalizaci

## Další poznámky

- Aplikace využívá Rails migrace pro správu databázových schémat
- Validace jsou definovány na úrovni modelů
- Použita strategie mazání závislých objektů:
    - Smazání uživatele → odstraní jeho projekty, úkoly a tagy
    - Smazání projektu → odstraní všechny jeho úkoly
    - Smazání tagu → neovlivní úkoly, pouze se odstraní vazba
- Optimalizace dotazů pomocí gemu `Bullet`


