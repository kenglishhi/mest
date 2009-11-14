/*!
 * job-grid.js
 * Kevin English, University of Hawaii
 */
Ext.bio.RunningJobGrid =  Ext.extend(Ext.bio.RestfulGrid, {
  useEditorFlag:true,
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
    dataIndex: 'run_at',
    renderer: Ext.util.Format.dateRenderer('m/d/Y H:i:s')
  }, {
    header: "Created At",
    autoWidth: true,
    sortable: true,
    dataIndex: 'run_at',
    renderer: Ext.util.Format.dateRenderer('m/d/Y H:i:s')
  } , {
    header: "Duration",
    autoWidth: true,
    sortable: true,
    dataIndex: 'duration_display'
  }, {
    header: "Priority",
    autoWidth: true,
    sortable: true,
    dataIndex: 'priority'
  }
  ],
  updateContent: function(params) {
    if(this.store.baseParams.option != params.option) {
      this.store.baseParams.option = params.option;
      this.store.load();
    }
  },
  refreshContent: function(params) {
    this.store.load();
  },
  initComponent: function() {
    var cmpId = this.id;


    Ext.apply(this,{
      tbar:[
      'Showing Running Jobs: ', ' ', 
      {
        iconCls:'x-tbar-loading',
        handler: function() {
          Ext.getCmp(cmpId).refreshContent( );
        }
      }]
    });

    Ext.bio.RunningJobGrid.superclass.initComponent.call(this);
  }
});
Ext.reg('running-job-grid', Ext.bio.RunningJobGrid);


Ext.bio.QueuedJobGrid =  Ext.extend(Ext.bio.RestfulGrid, {
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
    dataIndex: 'run_at',
    renderer: Ext.util.Format.dateRenderer('m/d/Y H:i:s')
  }, {
    header: "Created At",
    autoWidth: true,
    sortable: true,
    dataIndex: 'run_at',
    renderer: Ext.util.Format.dateRenderer('m/d/Y H:i:s')
  } , {
    header: "Duration",
    autoWidth: true,
    sortable: true,
    dataIndex: 'duration_display'
  }, {
    header: "Priority",
    autoWidth: true,
    sortable: true,
    dataIndex: 'priority'
  }
  ],
  updateContent: function(params) {
    if(this.store.baseParams.option != params.option) {
      this.store.baseParams.option = params.option;
      this.store.load();
    }
  },
  refreshContent: function(params) {
    this.store.load();
  },
  initComponent: function() {
    this.store.baseParams.option = 'Queued';
    var jobOptionStore = new Ext.data.ArrayStore({
      fields: ['option'],
      data : [ ['Queued'], ['Failed'] ]
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

    function onDelete() {
      var rec = Ext.getCmp(cmpId).getSelectionModel().getSelected();
      if (!rec) {
        return false;
      }
      Ext.getCmp(cmpId).store.remove(rec);
      Ext.getCmp(cmpId).refreshContent( );
    }

    combo.on('select', function(cmb, record) {
      Ext.getCmp(cmpId).updateContent( record.data);
    });

    combo.setValue("Queued");
    Ext.apply(this,{
      tbar:[
      'Show: ', ' ', combo,
      {
        iconCls:'x-tbar-loading',
        handler: function() {
          Ext.getCmp(cmpId).refreshContent( );
        }
      }, {
        text: 'Delete',
        iconCls:'x-tree-delete',
        handler: onDelete
      }
      ]
    });

    Ext.bio.QueuedJobGrid.superclass.initComponent.call(this);
  }
});
Ext.reg('queued-job-grid', Ext.bio.QueuedJobGrid);
