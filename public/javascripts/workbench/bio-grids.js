/*!
 * bio-grids.js
 * Kevin English, University of Hawaii
 */

Ext.bio.RestfulGrid =  Ext.extend(Ext.grid.GridPanel, {
  prefix: null,
  dataUrl:null,
  displayColumns: [ ],
  readerColumns:[ ],
  useEditorFlag:false,
  updateContent: function(params) {
  },
  initComponent: function() {

    var plugins = [];
    if (this.useEditorFlag){
      plugins[0] = this.editor;
      var editor = new Ext.ux.grid.RowEditor({
        saveText: 'Update'
      });
      plugins[0] = editor;
    }
    var pagingBar = null;
    if (this.usePagingBarFlag){
      pagingBar = new Ext.PagingToolbar({
        store: this.store,
        pageSize: this.pageSize,
        displayInfo: true,
        displayMsg: 'Displaying {0} - {1} of {2}',
        emptyMsg: "No data to display"
      });
    }


    Ext.apply(this,{
      tbar: pagingBar,
      loadMask: true,
      iconCls: 'icon-grid',
      frame: true,
      autoScroll: true,
      height: 300,
      //      autoHeight: true,
      plugins: plugins,
      columns : this.displayColumns,
      viewConfig: {
        forceFit: true
      }
    });

    Ext.bio.RestfulGrid.superclass.initComponent.call(this);
  } ,
  listeners: {
    render: function( p)  {
      this.store.load();
    }
  }
});


Ext.bio.BiodatabaseGrid =  Ext.extend(Ext.bio.RestfulGrid, {
  prefix: 'biodatabase-store',
  dataUrl: '/workbench/biodatabases',
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

Ext.bio.BiodatabaseGroupGrid =  Ext.extend(Ext.bio.RestfulGrid, {
  prefix: 'biodatabase-group-store',
  dataUrl: '/workbench/biodatabase_groups',
  useEditorFlag:true,
  usePagingBarFlag: true,
  displayColumns:  [ {
    header: "Name",
    width: 100,
    sortable: true,
    dataIndex: 'name',
    editor: new Ext.form.TextField({})
  } ],
  initComponent: function() {
    Ext.bio.BiodatabaseGroupGrid.superclass.initComponent.call(this);
  }
});
Ext.reg('biodatabase-group-grid', Ext.bio.BiodatabaseGroupGrid);


Ext.bio.BiosequenceGrid =  Ext.extend(Ext.bio.RestfulGrid, {
  prefix: 'biosequences',
  dataUrl: '/workbench/biosequences',
  pageSize: 50,
  biosequenceViewId: 'xxxx',
  usePagingBarFlag: true,
  displayColumns: [
  {
    header: "Name",
    sortable: true,
    autoWidth: true,
    dataIndex: 'name'
  }, {
    header: "Length",
    autoWidth: true,
    sortable: true,
    dataIndex: 'length'
  }
  ],
  initComponent: function() {

    var biosequenceViewId = this.biosequenceViewId;
    this.store.on('load',function() {
      var viewPanel = Ext.getCmp(biosequenceViewId);
      if (viewPanel) {
        var params = {
          rowIndex: 0
        };
        viewPanel.updateContent(params);
      }

    });

    Ext.bio.BiosequenceGrid.superclass.initComponent.call(this);
  },
  listeners: {
    afterrender: function( p)  {
      var viewPanel = Ext.getCmp(this.biosequenceViewId);
      viewPanel.setSource(this.store);
    },
    rowclick: function (grid, rowIndex, e) {
      var viewPanel = Ext.getCmp(this.biosequenceViewId);
      var params = {
        rowIndex: rowIndex
      };
      var biosequenceViewId;
      viewPanel.updateContent(params);
    }
  },
  updateContent: function(params) {
    this.store.baseParams.biodatabase_id = params.biodatabase_id;
    var viewPanel = Ext.getCmp(this.biosequenceViewId);
    this.store.load({
      params: {
        start: 0,
        limit: this.pageSize
      }
    } );
  }

});
Ext.reg('biosequence-grid', Ext.bio.BiosequenceGrid);

Ext.bio.BlastResultGrid =  Ext.extend(Ext.bio.RestfulGrid, {
  prefix: 'blast-result-group-store',
  dataUrl: '/workbench/blast_results',
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

