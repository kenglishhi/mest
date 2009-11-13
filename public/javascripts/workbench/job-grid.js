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
    dataIndex: 'run_at',
    renderer: Ext.util.Format.dateRenderer('m/d/Y H:i:s')
  }, {
    header: "Created At",
    autoWidth: true,
    sortable: true,
    dataIndex: 'run_at',
    renderer: Ext.util.Format.dateRenderer('m/d/Y H:i:s')
  } , {
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
      Ext.getCmp(cmpId).updateContent( record.data);
    });

    //    combo.on('change', function(cmb, newValue, oldValue) {
    //    });

    combo.setValue("Running");

    Ext.apply(this,{
      tbar:[
      'Show: ', ' ', combo,
      {
        iconCls:'x-tbar-loading',
        handler: function() {
          Ext.getCmp(cmpId).refreshContent( );
        }
      }]
    });

    Ext.bio.JobGrid.superclass.initComponent.call(this);
  }
});
Ext.reg('job-grid', Ext.bio.JobGrid);
