/*!
 * blast-result-grids.js
 * Kevin English, University of Hawaii
 */
Ext.bio.AlignmentsGrid =  Ext.extend(Ext.bio.RestfulGrid, {
  useEditorFlag:false,
  usePagingBarFlag: true,
  displayColumns:  [ 
  {
    header: "Label",
    authwidth: true,
    sortable: true,
    dataIndex: 'label'
  }, {
    header: "Alignment File Name",
    autoWidth: true,
    sortable: true,
    dataIndex: 'alignment_file_name_display',
    renderer: function(value, p, record, row, col, store) {
      return '<a href="' + record.data.alignment_file_url +'" target="_blank"  >' + record.data.alignment_file_name_display + '</a>';
    }
  }
  ],
  initComponent: function() {
    Ext.bio.AlignmentsGrid.superclass.initComponent.call(this);
  }
});

Ext.reg('alignments-grid', Ext.bio.AlignmentsGrid);
