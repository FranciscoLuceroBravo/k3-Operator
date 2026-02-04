clear all
cd "C:\Users\nelda\OneDrive\Documentos\RPM\RPM y ACN\k3 Operator"

* 1. Importar la base de datos (ajusta la ruta si es necesario)
import delimited "db_k3_gigante_ratio_autosave.csv", clear

* 3. Obtener el valor máximo y estadísticas descriptivas
summarize n, detail

local max_n = r(max)
local total_obs = r(N)

display "===================================================="
display "ANÁLISIS DE VALORES GENERADOS POR EL OPERADOR"
display "Total de datos procesados: `total_obs'"
display "Valor máximo de N encontrado: `max_n'"
display "===================================================="

* 4. Listar los primeros 100 N_original de menor a mayor
preserve
    gsort n
    list n in 1/100, separator(10)
restore

* 5. Adaptación para visualizar la distribución de 20 millones de datos (N hasta 10^16)
* --- FRAGMENTO EFICIENTE PARA 20.1M DE DATOS ---

* 1. Generar variable logarítmica si no existe
capture gen ln_n = ln(n)

* 2. Visualización rápida mediante histograma con escala logarítmica 
* (Es mucho más rápido que kdensity para 20 millones de registros)
* --- FRAGMENTO OPTIMIZADO Y RÁPIDO ---

preserve
    * Muestreo para velocidad (Grafica el 0.5% de los datos, suficiente para 20M)
    sample 0.5
    
    capture gen ln_n = ln(n)

    twoway (histogram ln_n, fcolor(navy%60) lcolor(navy%10) bin(100)), ///
        title("Distribución Global del Operador k=3") ///
        subtitle("Muestra representativa de 20.1M de registros") ///
        xtitle("ln(N) - Escala de Magnitud") ///
        ytitle("Densidad de Hallazgos") ///
        xline(9.21, lcolor(red) lpattern(dash)) /// * Nota: ln(10000) aprox 9.21
        note("La línea roja indica el límite superior de la OEIS analizada")

    * GUARDAR Y DESCARGAR
    graph export "Distribucion_Eficiente_k3.png", as(png) width(3200) replace
restore

