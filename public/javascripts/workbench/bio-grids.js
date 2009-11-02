/*!
 * bio-grids.js
 * Kevin English, University of Hawaii
 */
Ext.bio.SeqSearchField = Ext.extend(Ext.form.TwinTriggerField, {
  initComponent : function(){
    Ext.bio.SeqSearchField.superclass.initComponent.call(this);
    this.on('specialkey', function(f, e){
      if(e.getKey() == e.ENTER){
        this.onTrigger2Click();
      }
    }, this);
  },

  validationEvent:false,
  validateOnBlur:false,
  trigger1Class:'x-form-clear-trigger',
  trigger2Class:'x-form-search-trigger',
  hideTrigger1:true,
  width:180,
  hasSearch : false,
  paramName : 'query',

  onTrigger1Click : function(){
    if(this.hasSearch){
      this.el.dom.value = '';
      var o = {
        start: 0
      };
      this.store.baseParams = this.store.baseParams || {};
      this.store.baseParams[this.paramName] = '';
      this.store.reload({
        params:o
      });
      this.triggers[0].hide();
      this.hasSearch = false;
    }
  },

  onTrigger2Click : function(){
    var v = this.getRawValue();
    if(v.length < 1){
      this.onTrigger1Click();
      return;
    }
    var o = {
      start: 0
    };
    this.store.baseParams = this.store.baseParams || {};
    this.store.baseParams[this.paramName] = v;
    this.store.reload({
      params:o
    });
    this.hasSearch = true;
    this.triggers[0].show();
  }
});

Ext.bio.RestfulGrid =  Ext.extend(Ext.grid.GridPanel, {
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
      bbar: pagingBar,
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

    Ext.apply(this,{
      tbar:[
      'Search: ', ' ',
      new Ext.bio.SeqSearchField({
        store: this.store,
        width:320
      })
      ]
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

Ext.bio.JobGrid =  Ext.extend(Ext.bio.RestfulGrid, {
  useEditorFlag:false,
  usePagingBarFlag: true,
  displayColumns:  [ {
    header: "Job Name",
    autoWidth: true,
    sortable: true,
    dataIndex: 'job_name'
  }, {
    header: "Run At",
    autoWidth: true,
    sortable: true,
    dataIndex: 'run_at'
  }, {
    header: "Priority",
    autoWidth: true,
    sortable: true,
    dataIndex: 'priority'
  }
  ],
  updateContent: function(params) {
    console.log("Called updateContent() " + params.option );
    if(this.store.baseParams.option != params.option) {
      this.store.baseParams.option = params.option;
      this.store.load();
    }
  },
  initComponent: function() {
    var jobOptionStore = new Ext.data.ArrayStore({
      fields: ['option'],
      data : [['Running'], ['Queued'], ['Failed'] ]
    });

    var combo = new Ext.form.ComboBox({
      store: jobOptionStore ,
      displayField: 'option',
      allowBlank: false,
      editable: false,
      mode: 'local',
      triggerAction: 'all',
      selectOnFocus:true,
      forceSelection:true,
      width:135
    });
    var cmpId = this.id;

    combo.on('select', function(cmb, record) {
      console.log("Select has been applied " + record.data.option );
      Ext.getCmp(cmpId).updateContent( record.data);
    });

    //    combo.on('change', function(cmb, newValue, oldValue) {
    //      console.log("Change : " + newValue + ", " + oldValue );
    //    });

    combo.setValue("Running");

    Ext.apply(this,{
      tbar:[
      'Show: ', ' ', combo
      ]
    });

    Ext.bio.JobGrid.superclass.initComponent.call(this);
  }
});
Ext.reg('job-grid', Ext.bio.JobGrid);