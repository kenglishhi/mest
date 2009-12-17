/*!
 * blast-result-grids.js
 * Kevin English, University of Hawaii
 */
Ext.bio.BlastResultGrid =  Ext.extend(Ext.bio.RestfulGrid, {
  useEditorFlag:false,
  usePagingBarFlag: true,
  displayColumns:  [
  {
    header: "Output File Name",
    autoWidth: true,
    sortable: true,
    dataIndex: 'output_file_name_display',
    renderer: function(value, p, record, row, col, store) {
      return '<a href="' + record.data.output_file_url +'" target="_blank"  >' + record.data.output_file_name_display + '</a>';
    }
  },
  {
    header: "Job Name",
    autoWidth: true,
    sortable: true,
    dataIndex: 'name'
  }, {
    header: "Test Database",
    autoWidth: true,
    sortable: true,
    dataIndex: 'test_biodatabase_name'
  }, {
    header: "Duration (hh:mm:ss)",
    autoWidth: true,
    sortable: true,
    dataIndex: 'duration_display'
  }
  ],
  initComponent: function() {
    cmpId = this.id;
    function onDelete() {
      var grid = Ext.getCmp(cmpId);
      grid.deleteSelectedRow(true,'name') ;
    }

    Ext.apply(this,{
      tbar:[
      {
        xtype: 'tbtext',
        labelStyle: 'font-weight:bold;',
        cls:  'x-toolbar-item-bold' ,
        text: 'Title',
        id:   'blast-result-grid-title'
      },
      '->',
      {
        text: 'Delete',
        iconCls:'x-tree-delete',
        handler: onDelete
      }
      ]
    });
    Ext.bio.BlastResultGrid.superclass.initComponent.call(this);
  },
  updateContent: function(params) {
    if (params.biodatabase_id) {
      this.store.baseParams.biodatabase_id = params.biodatabase_id;
      this.store.load({
        params: {
          start: 0,
          limit: this.pageSize
        }
      } );
    }
  }
});
Ext.reg('blast-result-grid', Ext.bio.BlastResultGrid);