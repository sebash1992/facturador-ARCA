#!/bin/bash
# Corre una sola vez, en el primer arranque de Postgres (despues del schema).
# Crea los roles que usa PostgREST:
#   facturador    -> rol de trabajo. BYPASSRLS porque el schema activa RLS
#                    sin policies (deny-all): igual que la secret key de
#                    Supabase, este rol la saltea.
#   authenticator -> rol de conexion de PostgREST, que hace SET ROLE facturador.
set -e

psql -v ON_ERROR_STOP=1 -U "$POSTGRES_USER" -d "$POSTGRES_DB" <<-SQL
  create role facturador nologin bypassrls;
  grant usage on schema public to facturador;
  grant select, insert, update, delete on all tables in schema public to facturador;
  grant usage, select on all sequences in schema public to facturador;

  create role authenticator login noinherit password '${AUTHENTICATOR_PASSWORD}';
  grant facturador to authenticator;
SQL
