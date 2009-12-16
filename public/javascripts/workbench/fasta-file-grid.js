/*!
 * biodatabase-grid.js
 * Kevin English, University of Hawaii
 */

Ext.bio.FastaFileGrid =  Ext.extend(Ext.bio.RestfulGrid, {
  usePagingBarFlag: true,
  pageSize: 50,
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
  }, {
    header: "Uploaded Size",
    autoWidth: true,
    sortable: true,
    dataIndex: 'created_at'
  } ],
  initComponent: function() {
    Ext.apply(this,{
      tbar:[
      {
        iconCls: 'upload-icon',
        text:'Upload Fasta Files',
        handler: function() {
          Ext.bio.showFastaFileUploadWindow();
        }
      }]
    });
    Ext.bio.FastaFileGrid.superclass.initComponent.call(this);
  } ,
  updateContent: function(params) {
    this.store.load();
  },
  refreshContent: function(params) {
    this.store.load();
  }
});

Ext.reg('fasta-file-grid', Ext.bio.FastaFileGrid);