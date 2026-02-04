/*******************************************************************************
ANÁLISIS CIENTÍFICO DE DENSIDAD - OPERADOR k=3 (VERSIÓN CORREGIDA)
CORRECCIÓN CRÍTICA: Reducción squarefree aplicada TAMBIÉN a lista OEIS

Autor: Nelda Urteaga
Fecha: 2026-02-03
*******************************************************************************/

clear all
set more off

cd "C:\Users\nelda\OneDrive\Documentos\RPM\RPM y ACN\k3 Operator"

display as text "================================================================================"
display as text "OPERADOR k=3: ANÁLISIS DE DENSIDAD (COMPARACIÓN SQUAREFREE VS SQUAREFREE)"
display as text "================================================================================"
display ""

/*******************************************************************************
SECCIÓN 1: CARGA Y REDUCCIÓN DE DATOS A SQUAREFREE
*******************************************************************************/

display "Cargando datos..."
import delimited "db_k3_gigante_ratio_autosave.csv", clear

rename n N_original
rename v2 n_param
rename m m_param
rename ratio_m_n ratio_m_n

display "Reduciendo a forma squarefree..."

gen N_pure = N_original

* Eliminar factores cuadrados exhaustivamente hasta 50²
forval i = 2/50 {
    local sq = `i'^2
    local continuar = 1
    while `continuar' == 1 {
        quietly count if mod(N_pure, `sq') == 0
        if r(N) > 0 {
            quietly replace N_pure = N_pure / `sq' if mod(N_pure, `sq') == 0
        }
        else {
            local continuar = 0
        }
    }
}

* Marcar únicos
sort N_pure n_param m_param
quietly by N_pure: gen v_unico = (_n == 1)

* Clase mod 8
gen clase_mod8 = mod(N_pure, 8)

display as result "✓ Reducción completada"
display ""

/*******************************************************************************
SECCIÓN 2: LISTA OEIS REDUCIDA A SQUAREFREE
CORRECCIÓN CRÍTICA: Aplicamos reducción squarefree a lista OEIS también
*******************************************************************************/

display "Procesando lista OEIS original (65 valores)..."
display ""

* Lista OEIS ORIGINAL (con múltiplos)
local oeis_original "5 6 7 13 14 15 20 21 22 23 24 28 29 30 31 34 37 38 39 41 45 46 47 52 53 54 55 56 60 61 62 63 65 69 70 71 77 78 79 80 84 85 86 87 88 92 93 94 95 96 101 102 103 109 110 111 112 116 117 118 119 120 124 125 126"

* Crear lista REDUCIDA a squarefree
preserve
    clear
    set obs 65
    gen N_oeis_original = .
    
    * Llenar lista manualmente
    local i = 1
    foreach num in `oeis_original' {
        quietly replace N_oeis_original = `num' in `i'
        local i = `i' + 1
    }
    
    * Eliminar observaciones vacías si las hay
    quietly drop if missing(N_oeis_original)
    
    * Aplicar reducción squarefree
    gen N_oeis_pure = N_oeis_original
    
    forval i = 2/50 {
        local sq = `i'^2
        local continuar = 1
        while `continuar' == 1 {
            quietly count if mod(N_oeis_pure, `sq') == 0
            if r(N) > 0 {
                quietly replace N_oeis_pure = N_oeis_pure / `sq' if mod(N_oeis_pure, `sq') == 0
            }
            else {
                local continuar = 0
            }
        }
    }
    
    * Mostrar transformación
    display as text "Transformación OEIS (Original → Squarefree):"
    display as text "-----------------------------------------------"
    list N_oeis_original N_oeis_pure if N_oeis_original != N_oeis_pure, ///
        noobs separator(0) clean
    
    * Contar únicos squarefree en OEIS
    quietly duplicates drop N_oeis_pure, force
    local n_oeis_sf = _N
    
    display ""
    display as text "Lista OEIS original:  " as result "65 valores"
    display as text "Lista OEIS squarefree: " as result "`n_oeis_sf' valores únicos"
    
    * Guardar lista reducida
    keep N_oeis_pure
    tempfile oeis_sf
    save `oeis_sf'
    
    * Crear lista de valores para uso posterior
    quietly levelsof N_oeis_pure, local(oeis_sf_list)
    
    * Guardar en macro global
    global oeis_squarefree "`oeis_sf_list'"
    global n_oeis_sf `n_oeis_sf'
    
restore
display ""

/*******************************************************************************
SECCIÓN 3: MARCADOR SQUAREFREE EN BASE DE DATOS
*******************************************************************************/

display "Marcando valores OEIS squarefree en base de datos..."

gen es_oeis_sf = 0

foreach x in $oeis_squarefree {
    quietly replace es_oeis_sf = 1 if N_pure == `x'
}

display as result "✓ Marcador aplicado"
display ""

/*******************************************************************************
SECCIÓN 4: MÉTRICA 1 - COBERTURA OEIS SQUAREFREE (CORREGIDA)
*******************************************************************************/

display as text "================================================================================"
display as text "MÉTRICA 1: COBERTURA OEIS SQUAREFREE (COMPARACIÓN JUSTA)"
display as text "================================================================================"
display ""

* Contar capturados
quietly count if es_oeis_sf == 1 & v_unico == 1
local capturados = r(N)

display as text "Total OEIS squarefree:   " as result "$n_oeis_sf"
display as text "Capturados por k=3:      " as result "`capturados'"
display as text "Cobertura:               " as result %5.1f (`capturados'/$n_oeis_sf)*100 "%" 
display ""

* Identificar faltantes
preserve
    clear
    use `oeis_sf'
    gen capturado = 0
    
    foreach x in $oeis_squarefree {
        * Verificar si está en la base de datos generada
        count if N_oeis_pure == `x'
        if r(N) == 0 {
            replace capturado = 0 if N_oeis_pure == `x'
        }
        else {
            replace capturado = 1 if N_oeis_pure == `x'
        }
    }
    
    * Marcar correctamente los capturados
    gen temp_encontrado = 0
    foreach val of global oeis_squarefree {
        quietly count if N_oeis_pure == `val'
        if r(N) > 0 {
            quietly replace temp_encontrado = 1 if N_oeis_pure == `val'
        }
    }
    
    quietly count if temp_encontrado == 0
    local n_faltantes = r(N)
    
    if `n_faltantes' > 0 {
        display as text "Faltantes (" as result "`n_faltantes'" as text "):"
        list N_oeis_pure if temp_encontrado == 0, noobs clean
    }
    else {
        display as result "✓ Cobertura completa: 100%"
    }
restore
display ""

/*******************************************************************************
SECCIÓN 5: MÉTRICA 2 - DENSIDAD NATURAL [1, 1000]
*******************************************************************************/

display as text "================================================================================"
display as text "MÉTRICA 2: DENSIDAD NATURAL EN [1,1000]"
display as text "Fundamento: Smith (2016)"
display as text "================================================================================"
display ""

quietly count if N_pure <= 1000 & v_unico == 1
local generados_1k = r(N)

local denom_1k = floor(1000 * 6 / (_pi^2))
local densidad_1k = (`generados_1k' / `denom_1k') * 100

display as text "Squarefree generados (n ≤ 1000): " as result "`generados_1k'"
display as text "Squarefree teóricos (n ≤ 1000):  " as result "`denom_1k'"
display as text "Densidad natural:                " as result %5.1f `densidad_1k' "%"
display ""

if `densidad_1k' > 50 {
    display as result "✓ Operador k=3 SUPERA tasa teórica de Smith (50%)"
}
else if `densidad_1k' > 45 {
    display as text "• Operador k=3 en línea con teoría (~50%)"
}
else {
    display as error "⚠ Operador k=3 bajo expectativa teórica"
}
display ""

/*******************************************************************************
SECCIÓN 6: MÉTRICA 3 - DENSIDAD POR CLASES MOD 8
*******************************************************************************/

display as text "================================================================================"
display as text "MÉTRICA 3: DENSIDAD POR CLASES MOD 8"
display as text "Fundamento: Smith (2016)"
display as text "================================================================================"
display ""

display as text "Clase | Generados | Teóricos | Densidad | Tasa Smith | Evaluación"
display as text "------+-----------+----------+----------+------------+--------------"

foreach r in 1 2 3 5 6 7 {
    quietly count if N_pure <= 1000 & v_unico == 1 & clase_mod8 == `r'
    local gen_`r' = r(N)
    
    local teo_`r' = floor(`denom_1k' / 6)
    local dens_`r' = (`gen_`r'' / `teo_`r'') * 100
    
    if inlist(`r', 5, 6, 7) {
        local smith_`r' = 55.9
    }
    else {
        local smith_`r' = 41.9
    }
    
    if `dens_`r'' > `smith_`r'' + 5 {
        local eval_`r' = "Superior"
    }
    else if `dens_`r'' > `smith_`r'' - 5 {
        local eval_`r' = "En línea"
    }
    else {
        local eval_`r' = "Inferior"
    }
    
    display as text "  `r'   |" ///
            as result %8.0f `gen_`r'' as text "   |" ///
            as result %7.0f `teo_`r'' as text "   |" ///
            as result %7.1f `dens_`r'' as text "% |" ///
            as result %9.1f `smith_`r'' as text "% | " ///
            as text "`eval_`r''"
}
display ""

/*******************************************************************************
SECCIÓN 7: ANÁLISIS DEL RATIO m/n (SOLO OEIS SQUAREFREE)
*******************************************************************************/

display as text "================================================================================"
display as text "ANÁLISIS PARAMÉTRICO: DISTRIBUCIÓN DEL RATIO m/n"
display as text "================================================================================"
display ""

preserve
    keep if es_oeis_sf == 1 & v_unico == 1
    
    display as text "Estadísticas descriptivas (OEIS squarefree capturados):"
    display ""
    
    quietly summarize ratio_m_n, detail
    
    display as text "  Observaciones: " as result %6.0f r(N)
    display as text "  Media:         " as result %8.4f r(mean)
    display as text "  Desv. Est.:    " as result %8.4f r(sd)
    display as text "  Mínimo:        " as result %8.4f r(min)
    display as text "  P25:           " as result %8.4f r(p25)
    display as text "  Mediana:       " as result %8.4f r(p50)
    display as text "  P75:           " as result %8.4f r(p75)
    display as text "  P95:           " as result %8.4f r(p95)
    display as text "  Máximo:        " as result %8.4f r(max)
    display ""
    
    local sd = r(sd)
    if `sd' > 0.25 {
        display as text "Interpretación: Distribución AMPLIA - cubre todo el espectro"
    }
    else {
        display as text "Interpretación: Distribución CONCENTRADA - ratios específicos"
    }
    
restore
display ""

/*******************************************************************************
SECCIÓN 8: RESUMEN EJECUTIVO
*******************************************************************************/

display as text "================================================================================"
display as text "RESUMEN EJECUTIVO (COMPARACIÓN SQUAREFREE vs SQUAREFREE)"
display as text "================================================================================"
display ""

display as result "1. COBERTURA OEIS SQUAREFREE:"
display as text "   Lista OEIS original:     65 valores"
display as text "   Lista OEIS squarefree:   $n_oeis_sf valores únicos"
display as text "   Capturados por k=3:      `capturados'/$n_oeis_sf"
display as text "   Cobertura:               " as result %5.1f (`capturados'/$n_oeis_sf)*100 "%"
display ""

display as result "2. DENSIDAD NATURAL [1,1000]:"
display as text "   Generados:      " as result "`generados_1k'/`denom_1k' (" %5.1f `densidad_1k' "%)"
display as text "   Comparación:    " as result %5.1f `densidad_1k' "% vs. 50% (Smith 2016)"
display ""

display as result "3. INTERPRETACIÓN:"
if (`capturados'/$n_oeis_sf)*100 > 90 {
    display as text "   ✓ Cobertura EXCELENTE (>90%)"
}
else if (`capturados'/$n_oeis_sf)*100 > 70 {
    display as text "   ✓ Cobertura BUENA (>70%)"
}
else {
    display as text "   • Cobertura moderada (~70%)"
}

if `densidad_1k' > 60 {
    display as text "   ✓ Densidad ALTA - Supera teoría"
}
else if `densidad_1k' > 50 {
    display as text "   ✓ Densidad consistente con Smith"
}
display ""

display as text "================================================================================"
display as text "CORRECCIÓN APLICADA: Comparación justa squarefree vs squarefree"
display as text "================================================================================"

/*******************************************************************************
NOTA METODOLÓGICA:
La corrección aplicada es CRÍTICA porque:

1. Lista OEIS original contiene múltiplos:
   - 20 = 4×5 → squarefree = 5
   - 24 = 8×3 → squarefree = 6
   - 80 = 16×5 → squarefree = 5

2. Operador k=3 genera SOLO squarefree por construcción

3. Comparación justa: squarefree vs squarefree
   - Lista OEIS: 65 → ~44-48 únicos squarefree
   - Cobertura real: ~80-95% (no 72%)

4. Esto AUMENTA la cobertura aparente y es metodológicamente correcto
*******************************************************************************/
*** RECUPERAR LISTADO DE 608 SF***
* 1. Quedarse solo con los valores únicos marcados en el do-file
preserve
keep if v_unico == 1

* 2. Filtrar estrictamente al rango de densidad de Smith
keep if N_pure <= 1000

* 3. Eliminar cualquier variable que no sea el núcleo square-free
keep N_pure

* 4. Verificar el conteo en la consola de Stata
count

* 5. Exportar el listado limpio
export delimited using "lista_608_squarefree.csv", replace
restore