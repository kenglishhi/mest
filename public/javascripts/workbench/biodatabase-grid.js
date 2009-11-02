/*!
 * biodatabase-grid.js
 * Kevin English, University of Hawaii
 */

Ext.bio.BiodatabaseGrid =  Ext.extend(Ext.bio.RestfulGrid, {
  useEditorFlag:true,
  usePagingBarFlag: true,
  displayColumns:  [ {
    header: "Name",
    authwidth: true,
    sortable: true,
    dataIndex: 'name',
    editor: new Ext.form.TextField({})
  } , {
    header: "Fasta File Name",
    autoWidth: true,
    sortable: true,
    dataIndex: 'fasta_file_name_display',
    renderer: function(value, p, record, row, col, store) {
      return '<a href="' + record.data.fasta_file_url +'" target="_blank"  >' + record.data.fasta_file_name_display + '</a>';
    }
  } , {
    header: "Number of Seqs",
    authwidth: true,
    sortable: true,
    dataIndex: 'number_of_sequences'
  }  ],
  initComponent: function() {
    Ext.bio.BiodatabaseGrid.superclass.initComponent.call(this);
  } ,
  updateContent: function(params) {
    this.store.baseParams.biodatabase_group_id = params.biodatabase_group_id;
    this.store.load();
  }
});

Ext.reg('biodatabase-grid', Ext.bio.BiodatabaseGrid);