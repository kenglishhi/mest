/*!
 * job-grid.js
 * Kevin English, University of Hawaii
 */

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

Ext.bio.JobLogGrid =  Ext.extend(Ext.bio.RestfulGrid, {
  useEditorFlag:false,
  usePagingBarFlag: true,
  displayColumns:  [ {
    header: "Id",
    autoWidth: true,
    sortable: true,
    dataIndex: 'id'
  }, {
    header: "Job Name",
    autoWidth: true,
    sortable: true,
    dataIndex: 'job_name'
  }, {
    header: "Class",
    autoWidth: true,
    sortable: true,
    dataIndex: 'job_class_name'
  }, {
    header: "Duration",
    autoWidth: true,
    sortable: true,
    dataIndex: 'duration_in_seconds'
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

    Ext.bio.JobLogGrid.superclass.initComponent.call(this);
  }
});
Ext.reg('job-log-grid', Ext.bio.JobLogGrid);