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
    var App = new Ext.App({});

    // Create a standard HttpProxy instance.
    var proxy = new Ext.data.HttpProxy({
      url: this.dataUrl
    });

    // Typical JsonReader.  Notice additional meta-data params for defining the core attributes of your json-response
    var reader = new Ext.data.JsonReader({
      successProperty: 'success',
      idProperty: 'id',
      root: 'data'
    }, this.readerColumns
    );

    // The new DataWriter component.
    var writer = new Ext.data.JsonWriter();

    // Typical Store collecting the Proxy, Reader and Writer together.

    var plugins = [];
    if (this.useEditorFlag){
      plugins[0] = this.editor;
      var editor = new Ext.ux.grid.RowEditor({
        saveText: 'Update'
      });
      plugins[0] = editor;
    }

    Ext.apply(this,{
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
  displayColumns:  [ {
    header: "ID",
    width: 40,
    sortable: true,
    dataIndex: 'id'
  }, {
    header: "Name",
    width: 100,
    sortable: true,
    dataIndex: 'name',
    editor: new Ext.form.TextField({})
  } ],
  readerColumns: [ {
    name: 'id'
  }, {
    name: 'name',
    allowBlank: false
  } ] ,
  initComponent: function() {
    Ext.bio.BiodatabaseGrid.superclass.initComponent.call(this);
  } ,
  listeners: {
    render: function( p)  {
    }
  },
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
  displayColumns:  [ {
    header: "ID",
    width: 40,
    autoWidth: true,
    sortable: true,
    dataIndex: 'id'
  }, {
    header: "Name",
    width: 100,
    sortable: true,
    dataIndex: 'name',
    editor: new Ext.form.TextField({})
  } ],
  readerColumns: [ {
    name: 'id'
  }, {
    name: 'name',
    allowBlank: false
  } ] ,
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
  displayColumns: [
  {
    header: "Name",
    //    width: 25,
    sortable: true,
    autoWidth: true,
    dataIndex: 'name'
  }, {
    header: "Length",
    //    width: 10,
    autoWidth: true,
    sortable: true,
    dataIndex: 'length'

  }
  ],
  readerColumns:[
  {
    name: 'id'
  } , {
    name: 'name',
    allowBlank: false
  } , {
    name: 'length'
  }
  ],

  initComponent: function() {
    var pagingBar = new Ext.PagingToolbar({
      store: this.store,
      pageSize: this.pageSize,
      displayInfo: true,
      displayMsg: 'Displaying {0} - {1} of {2}',
      emptyMsg: "No data to display"
    });

    Ext.apply(this,{
      tbar: pagingBar
    });
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
