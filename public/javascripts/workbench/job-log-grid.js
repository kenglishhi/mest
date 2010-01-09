/*!
 * job-grid.js
 * Kevin English, University of Hawaii
 */

Ext.bio.JobLogGrid =  Ext.extend(Ext.bio.RestfulGrid, {
  useEditorFlag:false,
  usePagingBarFlag: true,
  displayColumns:  [  {
    header: "Job Name",
    autoWidth: true,
    sortable: true,
    dataIndex: 'job_name'
  } , {
    header: "User",
    autoWidth: true,
    sortable: true,
    dataIndex: 'user_email'
  }  , {
    header: "Duration (hh:mm:ss)",
    autoWidth: true,
    sortable: true,
    dataIndex: 'duration_display'
  } , {
    header: "Finished",
    autoWidth: true,
    sortable: true,
    dataIndex: 'stopped_at',
    renderer: Ext.util.Format.dateRenderer('m/d/Y H:i:s')
  } , {
    header: "Success",
    autoWidth: true,
    sortable: true,
    dataIndex: 'success'
  },{
    header: "Estimation Error",
    autoWidth: true,
    sortable: true,
    dataIndex: 'estimation_error_seconds'
  }  ],
  updateContent: function(params) {
  },
  initComponent: function() {
    Ext.bio.JobLogGrid.superclass.initComponent.call(this);
  }
});

Ext.reg('job-log-grid', Ext.bio.JobLogGrid);
