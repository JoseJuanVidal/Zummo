/* ====================================================================
   Configuración del dashboard de producción (se carga antes que Dashboard_Zummo.html)
   - apiUrl: dirección del servicio DashboardProduccion, que lee y guarda en Business Central.
             Solo se usa al abrir el HTML como fichero (carpeta de SharePoint); abierto desde
             http://servidor:5090 se usa siempre ese mismo servidor.
   - perfiles: GAPs con sus KPIs, objetivos, secciones y colores.
   - checklist: puntos de la rutina del supervisor (key = clave en BC: no cambiarla si ya hay datos).
   No poner aquí contraseñas: este fichero lo puede leer cualquiera que tenga la carpeta.
   ==================================================================== */
window.DASHBOARD_CONFIG = {
  apiUrl: 'http://localhost:5090',

  perfiles: {
    repuestos: {
      gap: 'REPUESTOS',   // código del GAP en BC (campo GAP Code)
      name: 'GAP REPUESTOS',
      tag:  'GAP Repuestos',
      tagBg: '#EBE3F5', tagFg: '#8A6FB3',
      sections: [ {code:'Q', name:'CALIDAD (Q)'}, {code:'P', name:'PERSONAL (P)'} ],
      // code = clave del KPI en BC: no cambiarla si ya hay datos guardados
      kpis: [
        { code:'Q3',  section:'Q', name:'Nº de reclamaciones de clientes por errores de producción', unit:'uds',  obj:0,   base:null, higherIsBetter:false, aggWeek:'sum',  aggYear:'sum',  color:'#1E73BE' },
        { code:'Q5',  section:'Q', name:"Nº NOK's auditorías de calidad",                            unit:'uds',  obj:0,   base:null, higherIsBetter:false, aggWeek:'sum',  aggYear:'sum',  color:'#2E9E5B' },
        { code:'Q13', section:'Q', name:'Errores en Kanban detectados en auditorías',                unit:'uds',  obj:0,   base:null, higherIsBetter:false, aggWeek:'sum',  aggYear:'sum',  color:'#8A6FB3' },
        { code:'P7',  section:'P', name:'Nº días sin accidentes',                                    unit:'días', obj:510, base:null, higherIsBetter:true,  aggWeek:'last', aggYear:'last', color:'#E78A2C' }
      ]
    },
    exprimidoras: {
      gap: 'EXPRIMIDORAS',   // código del GAP en BC (campo GAP Code)
      name: 'GAP EXPRIMIDORAS',
      tag:  'GAP Exprimidoras',
      tagBg: '#FEE7D5', tagFg: '#C46016',
      sections: [ {code:'Q', name:'CALIDAD (Q)'}, {code:'D', name:'ENTREGA (D)'}, {code:'P', name:'PERSONAL (P)'} ],
      // code = clave del KPI en BC: no cambiarla si ya hay datos guardados
      kpis: [
        { code:'Q3',  section:'Q', name:'Nº de reclamaciones de clientes por errores de producción', unit:'uds', obj:0,     base:null, higherIsBetter:false, aggWeek:'sum',  aggYear:'sum',  color:'#1E73BE' },
        { code:'Q5',  section:'Q', name:"Nº NOK's auditorías de calidad",                            unit:'uds', obj:0,     base:null, higherIsBetter:false, aggWeek:'sum',  aggYear:'sum',  color:'#2E9E5B' },
        { code:'Q13', section:'Q', name:'Errores en Kanban detectados en auditorías',                unit:'uds', obj:0,     base:null, higherIsBetter:false, aggWeek:'sum',  aggYear:'sum',  color:'#8A6FB3' },
        { code:'Q14', section:'Q', name:'FPY (% de máquinas OK a la primera)',                       unit:'%',   obj:0.98,  base:null, higherIsBetter:true,  aggWeek:'avg',  aggYear:'avg',  color:'#1E73BE' },
        { code:'Q16', section:'Q', name:'Errores humanos',                                           unit:'uds', obj:0,     base:null, higherIsBetter:false, aggWeek:'sum',  aggYear:'sum',  color:'#D9534F' },
        { code:'D5',  section:'D', name:'Cumplimiento del tablero de marcha',                        unit:'%',   obj:1.0,   base:null, higherIsBetter:true,  aggWeek:'avg',  aggYear:'avg',  color:'#2E9E5B' },
        { code:'P7',  section:'P', name:'Nº días sin accidentes',                                    unit:'días',obj:null,  base:null, higherIsBetter:true,  aggWeek:'last', aggYear:'last', color:'#E78A2C' }
      ]
    }
  },

  checklist: [
    { key:'indicadores', icon:'📊', title:'Revisar los indicadores y que no haya fallos',
      sub:'Cuadro de mando diario, cumplimiento Q, D, P.' },
    { key:'actas',       icon:'📝', title:'Revisar que las Actas de TOP 5 están rellenas',
      sub:'Pestaña Acta TOP 5 del día.' },
    { key:'planes',      icon:'📌', title:'Revisar que los planes de acción están actualizados',
      sub:'Pestaña Plan de acción: fechas, estados, cierres.' },
    { key:'limpieza',    icon:'🧹', title:'Revisar que las líneas están limpias y ordenadas',
      sub:'Inspección visual del GAP.' }
  ]
};
