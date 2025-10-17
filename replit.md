# WebNexus - Scraper Development Allocation & Tracking System

## Overview

WebNexus is a comprehensive web application designed to manage the allocation and tracking of 1000+ scrapers across a development team of 7 developers. The system provides dashboard analytics, developer workload management, scraper tracking, allocation management, query tracking, package management, and reporting capabilities.

## User Preferences

Preferred communication style: Simple, everyday language.

## System Architecture

### Frontend Architecture

**Framework & Build System**
- React 18+ with TypeScript for type-safe component development
- Vite as the build tool and development server for fast HMR and optimized production builds
- Wouter for lightweight client-side routing instead of React Router
- TanStack Query (React Query) for server state management with automatic caching and background refetching

**UI Component Strategy**
- Radix UI primitives for accessible, unstyled component foundation
- Tailwind CSS for utility-first styling with custom design tokens
- shadcn/ui components (New York style) for consistent, pre-built UI patterns
- CSS variables for theming with light/dark mode support

**State Management Approach**
- React Query handles all server state (developers, scrapers, allocations, queries, packages)
- React Hook Form with Zod validation for form state and validation
- Local component state for UI-only concerns
- No global state management library needed due to React Query's cache

### Backend Architecture

**Server Framework**
- Express.js with TypeScript for the REST API server
- Custom middleware for request logging, JSON body parsing, and error handling
- Session-based authentication with PostgreSQL session store

**API Design Pattern**
- RESTful endpoints organized by resource (`/api/developers`, `/api/scrapers`, etc.)
- Consistent error handling with appropriate HTTP status codes
- Request validation using Zod schemas derived from Drizzle schema definitions
- Authentication middleware protecting all API routes except login

**Database Layer**
- Drizzle ORM for type-safe database queries and schema management
- Neon serverless PostgreSQL as the database provider
- Schema-first design with TypeScript types generated from database schema
- Migration management through `drizzle-kit push` for schema changes

### Data Storage Solutions

**Database Schema Design**
- **Users Table**: Stores authentication data (email, name, profile image, role)
- **Developers Table**: Links to users, tracks skills, workload capacity, and current assignments
- **Scrapers Table**: Comprehensive scraper metadata (priority, complexity, status, frequency, etc.)
- **Allocations Table**: Junction table managing developer-scraper assignments with history
- **Queries Table**: Tracks questions/issues related to scrapers
- **Packages Table**: Manages deployment packages with status tracking
- **Status Changes Table**: Audit log for scraper status transitions
- **Sessions Table**: Stores encrypted session data for authentication (required by Replit Auth)

**Relationships**
- One-to-one between users and developers
- Many-to-many between developers and scrapers through allocations
- One-to-many from scrapers to queries, packages, and status changes
- Drizzle relations defined for easy query joining

### Authentication & Authorization

**Authentication Provider**
- Replit Auth (OIDC-based) for user authentication
- Passport.js strategy for OIDC integration
- Express session middleware with PostgreSQL-backed session storage
- Automatic session refresh and token management

**Authorization Model**
- Role-based access control with roles: admin, developer, viewer
- Authentication middleware (`isAuthenticated`) protects all API routes
- Frontend redirects to `/api/login` for unauthenticated users
- User profile and role stored in session after authentication

**Session Management**
- 7-day session TTL with secure, HTTP-only cookies
- Session data stored in PostgreSQL for persistence across server restarts
- Memoized OIDC configuration for performance (1-hour cache)

### External Dependencies

**Third-Party Services**
- **Neon Database**: Serverless PostgreSQL database hosting with WebSocket support
- **Replit Auth**: OIDC authentication provider (issuer: `replit.com/oidc`)
- **Google Fonts**: Inter and Roboto font families loaded on-demand

**Key NPM Packages**
- **@neondatabase/serverless**: PostgreSQL client with WebSocket support for Neon
- **drizzle-orm** & **drizzle-kit**: Type-safe ORM and migration tools
- **@tanstack/react-query**: Server state management and caching
- **react-hook-form** & **@hookform/resolvers**: Form handling with Zod validation
- **openid-client** & **passport**: OIDC authentication flow
- **express-session** & **connect-pg-simple**: Session management with PostgreSQL
- **@radix-ui/***: Accessible UI component primitives
- **tailwindcss**: Utility-first CSS framework
- **zod**: Schema validation for runtime type checking
- **wouter**: Lightweight routing library

**Development Tools**
- **@replit/vite-plugin-***: Replit-specific development tooling (runtime errors, cartographer, dev banner)
- **tsx**: TypeScript execution for development server
- **esbuild**: Fast bundling for production server build