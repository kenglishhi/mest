/*!
 * biodatabase-grid.js
 * Kevin English, University of Hawaii
 */

Ext.bio.FastaFileGrid =  Ext.extend(Ext.bio.RestfulGrid, {
  usePagingBarFlag: true,
  displayColumns:  [ {
    header: "Label",
    authwidth: true,
    sortable: true,
    dataIndex: 'label'
  }, {
    header: "Fasta File Name",
    autoWidth: true,
    sortable: true,
    dataIndex: 'fasta_file_name_display',
    renderer: function(value, p, record, row, col, store) {
      return '<a href="' + record.data.fasta_file_url + '" target="_blank"  >' + record.data.fasta_file_name_display + '</a>';
    }
  }, {
    header: "File Size",
    autoWidth: true,
    sortable: true,
    dataIndex: 'fasta_file_size_display'
  } ],
  initComponent: function() {
    Ext.bio.FastaFileGrid.superclass.initComponent.call(this);
  } ,
  updateContent: function(params) {
    this.store.baseParams.biodatabase_group_id = params.biodatabase_group_id;
    this.store.load();
  }
});

Ext.reg('fasta-file-grid', Ext.bio.FastaFileGrid);