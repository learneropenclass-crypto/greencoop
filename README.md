# 🌱 GreenAndCoop - Pipeline de données météorologiques

## 📋 Contexte du projet

GreenAndCoop est un fournisseur coopératif français d'électricité d'origine 
renouvelable dans les Hauts-de-France. Ce projet **Forecast 2.0** vise à 
intégrer des données météorologiques de stations semi-professionnelles pour 
améliorer les modèles de prévision de la demande électrique.

## 🎯 Objectifs

- Collecter quotidiennement des données météorologiques de qualité
- Transformer et tester les données via dbt
- Mettre à disposition des Data Scientists des données fiables et documentées

## 🗺️ Sources de données

| Source | Type | Localisation |
|--------|------|-------------|
| InfoClimat - Bergues | Station semi-pro | Nord, France |
| InfoClimat - Hazebrouck | Station semi-pro | Nord, France |
| InfoClimat - Armentières | Station semi-pro | Nord, France |
| InfoClimat - Lille-Lesquin | Station semi-pro | Nord, France |
| Weather Underground - Ichtegem | Station amateur | Belgique |
| Weather Underground - La Madeleine | Station amateur | Nord, France |

## 🏗️ Architecture technique


```text
┌──────────────────────────────────────────────────────────┐
│                    SOURCES DE DONNÉES                    │
│  InfoClimat API  │  Weather Underground  │  Fichiers CSV │
└────────┬─────────────────────┬───────────────────┬───────┘
         │                     │                   │
         ▼                     ▼                   ▼
┌─────────────────────────────────────────────────────────┐
│                      AIRBYTE                            │
│              Ingestion & Synchronisation                │
└─────────────────────────┬───────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│                    POSTGRESQL                           │
│  RAW → STAGING → INTERMEDIATE → MARTS                   │
└─────────────────────────┬───────────────────────────────┘
                          │
                          ▼
┌─────────────────────────────────────────────────────────┐
│                       DBT                               │
│         Transformation, Tests, Documentation            │
└─────────────────────────────────────────────────────────┘



## 🛠️ Stack technique

| Outil | Version | Usage |
|-------|---------|-------|
| Docker | latest | Conteneurisation |
| Docker Compose | v2 | Orchestration locale |
| PostgreSQL | 15 | Base de données |
| Airbyte | latest | Ingestion de données |
| dbt-core | 1.7+ | Transformation |
| Python | 3.10+ | Scripts & notebooks |

## 📁 Structure du projet
greencoop/
├── README.md
├── .env.example              # Template variables d'environnement
├── .gitignore
├── docker/
│   └── docker-compose.yml    # PostgreSQL + Airbyte
├── dbt/
│   ├── dbt_project.yml
│   ├── profiles.yml.example
│   └── models/
│       ├── raw/              # Données brutes ingérées
│       ├── staging/          # Nettoyage et typage
│       ├── intermediate/     # Jointures et enrichissement
│       └── marts/            # Tables finales pour Data Scientists
├── data/
│   └── raw/                  # Fichiers sources
└── notebooks/
    └── exploration.ipynb     # Analyse exploratoire

## 🚀 Installation et démarrage

### Prérequis
- Docker Desktop installé
- Python 3.10+
- Git

### 1. Cloner le repository
```bash
git clone https://github.com/learneropenclass-crypto/greencoop.git
cd greencoop
2. Configurer les variables d'environnement
cp .env.example .env
# Éditer .env avec vos propres valeurs
3. Lancer PostgreSQL et Airbyte
cd docker
docker-compose up -d
4. Accéder aux interfaces

Airbyte : http://localhost:8000
PostgreSQL : localhost:5432

5. Installer dbt
pip install dbt-postgres
cd dbt
cp profiles.yml.example profiles.yml
# Éditer profiles.yml avec vos credentials
dbt debug    # Vérifier la connexion
dbt run      # Lancer les transformations
dbt test     # Lancer les tests qualité
🔄 Pipeline de données
1. COLLECT   → Airbyte synchronise les sources toutes les 24h
2. RAW       → Données brutes stockées sans transformation
3. STAGING   → Nettoyage, typage, renommage des colonnes
4. INTERMEDIATE → Jointures entre stations, calculs intermédiaires
5. MARTS     → Tables finales optimisées pour les Data Scientists
✅ Contrôle qualité des données
Les tests dbt vérifient automatiquement :

Not null : colonnes critiques non vides
Unique : pas de doublons sur les clés
Accepted values : valeurs dans les plages attendues
Relationships : intégrité référentielle

📊 Schéma de la base de données
Voir docs/schema_etoile.png
🔒 Sécurité

Les credentials ne sont jamais committés sur GitHub
Utiliser .env (ignoré par git) pour les mots de passe
profiles.yml dbt également ignoré par git

👤 Auteur
Projet réalisé dans le cadre de la formation Data Engineer - OpenClassroomsEntreprise fictive : GreenAndCoop, Hauts-de-France
