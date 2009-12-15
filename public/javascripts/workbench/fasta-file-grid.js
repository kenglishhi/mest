/*!
 * biodatabase-grid.js
 * Kevin English, University of Hawaii
 */

Ext.bio.FastaFileGrid =  Ext.extend(Ext.bio.RestfulGrid, {
  useEditorFlag:true,
  usePagingBarFlag: true,
  displayColumns:  [ {
    header: "Name",
    authwidth: true,
    sortable: true,
    dataIndex: 'name',
    editor: new Ext.form.TextField({})
  }  ],
  initComponent: function() {
    Ext.bio.FastaFileGrid.superclass.initComponent.call(this);
  } ,
  updateContent: function(params) {
    this.store.baseParams.biodatabase_group_id = params.biodatabase_group_id;
    this.store.load();
  }
});

Ext.reg('fasta-file-grid', Ext.bio.FastaFileGrid);