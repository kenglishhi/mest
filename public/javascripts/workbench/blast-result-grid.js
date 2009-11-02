/*!
 * blast-result-grids.js
 * Kevin English, University of Hawaii
 */
Ext.bio.BlastResultGrid =  Ext.extend(Ext.bio.RestfulGrid, {
  useEditorFlag:false,
  usePagingBarFlag: true,
  displayColumns:  [ {
    header: "Name",
    autoWidth: true,
    sortable: true,
    dataIndex: 'name'
  }, {
    header: "Output File Name",
    autoWidth: true,
    sortable: true,
    dataIndex: 'output_file_name_display',
    renderer: function(value, p, record, row, col, store) {
      return '<a href="' + record.data.output_file_url +'" target="_blank"  >' + record.data.output_file_name_display + '</a>';
    }
  }, {
    header: "Command",
    autoWidth: true,
    sortable: true,
    dataIndex: 'command'
  },{
    header: "Started",
    autoWidth: true,
    sortable: true,
    dataIndex: 'started_at'
  },{
    header: "Stopped",
    autoWidth: true,
    sortable: true,
    dataIndex: 'stopped_at'
  }
  ],
  initComponent: function() {
    Ext.bio.BlastResultGrid.superclass.initComponent.call(this);
  }
});
Ext.reg('blast-result-grid', Ext.bio.BlastResultGrid);
