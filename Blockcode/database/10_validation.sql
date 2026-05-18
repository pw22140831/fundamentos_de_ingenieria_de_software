-- =====================================================
-- VERIFICACION BASICA DE OBJETOS
-- PostgreSQL
-- =====================================================

SELECT
    'TABLAS' AS tipo_objeto,
    COUNT(*) AS total
FROM information_schema.tables
WHERE table_schema = 'public'
AND table_type = 'BASE TABLE'

UNION ALL

SELECT
    'VISTAS' AS tipo_objeto,
    COUNT(*) AS total
FROM information_schema.views
WHERE table_schema = 'public'

UNION ALL

SELECT
    'INDICES' AS tipo_objeto,
    COUNT(*) AS total
FROM pg_indexes
WHERE schemaname = 'public'

UNION ALL

SELECT
    'TRIGGERS' AS tipo_objeto,
    COUNT(*) AS total
FROM information_schema.triggers
WHERE trigger_schema = 'public'

UNION ALL

SELECT
    'FUNCIONES' AS tipo_objeto,
    COUNT(*) AS total
FROM information_schema.routines
WHERE routine_schema = 'public'
AND routine_type = 'FUNCTION'

UNION ALL

SELECT
    'PROCEDIMIENTOS' AS tipo_objeto,
    COUNT(*) AS total
FROM information_schema.routines
WHERE routine_schema = 'public'
AND routine_type = 'PROCEDURE'

ORDER BY tipo_objeto;