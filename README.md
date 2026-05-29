# 🌱 GreenAndCoop - Pipeline de données météorologiques

## 📋 Contexte du projet

GreenAndCoop est un fournisseur coopératif français d'électricité d'origine renouvelable dans les Hauts-de-France. Ce projet **Forecast 2.0** vise à intégrer des données météorologiques de stations semi-professionnelles pour améliorer les modèles de prévision de la demande électrique.

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

\\\
SOURCES
  ├─ InfoClimat API
  ├─ Weather Underground
  └─ Fichiers CSV
       ↓
    AIRBYTE (Ingestion)
       ↓
  POSTGRESQL
  ├─ raw/        (Données brutes)
  ├─ staging/    (Nettoyage)
  ├─ intermediate/ (Transformation)
  └─ marts/      (Tables finales)
       ↓
      DBT
  ├─ Tests qualité
  ├─ Documentation
  └─ Data Scientists
\\\

## 🛠️ Stack technique

| Outil | Version | Usage |
|-------|---------|-------|
| Docker | latest | Conteneurisation |
| PostgreSQL | 15 | Base de données |
| Airbyte | latest | Ingestion de données |
| dbt-core | 1.7+ | Transformation |
| Python | 3.10+ | Scripts & notebooks |

## 📁 Structure du projet

\\\
greencoop/
├── README.md
├── .env.example
├── .gitignore
├── docker/
│   ├── docker-compose.yml
│   └── README.md
├── dbt/
│   ├── dbt_project.yml
│   ├── profiles.yml.example
│   └── models/
│       ├── raw/
│       │   └── sources.yml
│       ├── staging/
│       │   ├── stg_infoclimat.sql
│       │   └── stg_weather_underground.sql
│       ├── intermediate/
│       │   └── int_weather_unified.sql
│       └── marts/
│           ├── dim_weather_stations.sql
│           ├── fct_weather_observations.sql
│           └── schema.yml
├── data/
│   └── raw/
│       ├── Data_Source1_011024-071024.json
│       ├── Weather_Underground_Ichtegem_BE.xlsx
│       ├── Weather_Underground_La_Madeleine_FR.xlsx
│       └── README.md
├── notebooks/
│   └── exploration.ipynb
└── docs/
\\\

## 🚀 Installation et démarrage

### Prérequis

- Docker Desktop installé
- Python 3.10+
- Git

### 1. Cloner le repository

\\\ash
git clone https://github.com/learneropenclass-crypto/greencoop.git
cd greencoop
\\\

### 2. Configurer les variables d'environnement

\\\ash
cp .env.example .env
# Éditer .env avec vos propres valeurs
\\\

### 3. Lancer PostgreSQL et pgAdmin

\\\ash
cd docker
docker-compose up -d
\\\

**Accès :**
- pgAdmin : http://localhost:5050
- PostgreSQL : localhost:5432

### 4. Installer dbt

\\\ash
pip install dbt-postgres
cd dbt
cp profiles.yml.example profiles.yml
# Éditer profiles.yml avec vos credentials
dbt debug    # Vérifier la connexion
dbt run      # Lancer les transformations
dbt test     # Lancer les tests qualité
\\\

## 🔄 Pipeline de données

\\\
1. COLLECT   → Airbyte synchronise les sources toutes les 24h
2. RAW       → Données brutes stockées sans transformation
3. STAGING   → Nettoyage, typage, renommage des colonnes
4. INTERMEDIATE → Jointures entre stations, calculs intermédiaires
5. MARTS     → Tables finales optimisées pour les Data Scientists
\\\

## ✅ Contrôle qualité des données

Les tests dbt vérifient automatiquement :

- **Not null** : colonnes critiques non vides
- **Unique** : pas de doublons sur les clés
- **Accepted values** : valeurs dans les plages attendues
- **Relationships** : intégrité référentielle

## 📊 Tables finales

### fct_weather_observations
Table de faits contenant :
- observation_id (PK)
- datetime
- station_name
- temperature, humidity, pressure
- data_quality_flag

### dim_weather_stations
Dimension contenant :
- station_id (PK)
- station_name
- coordinates (latitude, longitude)
- country

## 🔒 Sécurité

- ✅ Les credentials ne sont jamais committés sur GitHub
- ✅ Utiliser \.env\ (ignoré par git) pour les mots de passe
- ✅ \dbt/profiles.yml\ également ignoré par git
- ✅ Fichiers sensibles dans \.gitignore\

## 👤 Auteur

Projet réalisé dans le cadre de la formation Data Engineer - OpenClassrooms

Entreprise fictive : GreenAndCoop, Hauts-de-France

---

**Dernière mise à jour :** 29/05/2026
