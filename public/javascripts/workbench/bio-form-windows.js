Ext.bio.BiodatabaseRenamerWindow = Ext.extend(Ext.Window,{
  title: 'Rename Sequences',
  layout:'fit',
  width:500,
  height:220,
  closeAction:'hide',
  plain: true,
  id:'bio-db-renamer-window',
  initComponent: function() {
    var parentComponentId = this.id;
    var combo = new Ext.form.ComboBox({
      fieldLabel: 'Database',
      name:'biodatabase',
      id:'biodatabase-id-rename-field',
      hiddenName : 'biodatabase_id',
      valueField:'id',
      displayField:'name',
      store: this.dbStore,
      typeAhead: true,
      mode: 'local',
      triggerAction: 'all',
      emptyText:'Select a database...',
      selectOnFocus:true,
      width: 350,
      listWidth: 350,
      allowBlank:false
    });

    var form = new Ext.FormPanel({
      id: 'my-renamer-form-panel',
      labelWidth: 75, // label settings here cascade unless overridden
      url:'/tools/biosequence_renamers.json',
      method: 'POST',
      baseParams:{
        authenticity_token: FORM_AUTH_TOKEN
      },
      frame:true,
      bodyStyle:'padding:5px 5px 0',
      defaults: {
        width: 230
      },
      defaultType: 'textfield',
      items: [combo
      , {
        fieldLabel: 'New Prefix',
        name: 'prefix',
        allowBlank:false
      }
      ],
      buttons: [{
        text: 'Save',
        handler: function(){
          var form = Ext.getCmp('my-renamer-form-panel').getForm();
          if (form && form.isValid()) {
            form.submit({
              success: function(form, action) {
                Ext.getCmp(parentComponentId).hide();
              //Ext.bio.notifier.show('Sequences Renamed', 'Finished renaming seqeuneces');
              }
            });
          }
        }
      },
      {
        text: 'Cancel',
        handler: function(){
          Ext.getCmp(parentComponentId).hide();
        }
      }
      ]
    });

    Ext.apply(this,{ 
      items:   form
    });
    Ext.bio.BiodatabaseRenamerWindow.superclass.initComponent.call(this);
  },
  setBiodatabaseId: function(biodatabaseId) {
    Ext.getCmp('biodatabase-id-rename-field').setValue(biodatabaseId);
  }
});

Ext.bio.BlastCleanerWindow = Ext.extend(Ext.Window,{
  title: 'Clean DB with Blast',
  layout:'fit',
  width:500,
  height:220,
  closeAction:'hide',
  plain: true,
  id: 'bio-blast-cleaners-window',
  initComponent: function() {
    var parentComponentId = this.id;
    var combo = new Ext.form.ComboBox({
      fieldLabel: 'Database',
      name:'biodatabase',
      id: 'biodatabase-id-clean-field',
      hiddenName : 'biodatabase_id',
      valueField:'id',
      displayField:'name',
      store: this.dbStore,
      typeAhead: true,
      mode: 'local',
      triggerAction: 'all',
      emptyText:'Select a database...',
      selectOnFocus:true,
      width: 350,
      listWidth: 350,
      allowBlank:false
    });
    var form = new Ext.FormPanel({
      id: 'my-blast-cleaners-form-panel',
      labelWidth: 120, // label settings here cascade unless overridden
      url:'/tools/blast_cleaners.json',
      method: 'POST',
      baseParams:{
        authenticity_token: FORM_AUTH_TOKEN
      },
      frame:true,
      bodyStyle:'padding:5px 5px 0',
      defaults: {
        width: 230
      },
      defaultType: 'textfield',
      items: [combo,
      {
        fieldLabel: 'New Database Name',
        name: 'new_biodatabase_name',
        allowBlank:true,
        msgTarget:'side'
      } , {
        fieldLabel: 'E-Value',
        name: 'evalue',
        value:'25',
        allowBlank:true
      }
      ],
      buttons: [{
        text: 'Submit',
        handler: function(){
          var form = Ext.getCmp('my-blast-cleaners-form-panel').getForm();
          if (form && form.isValid()) {
            form.submit({
              waitMsg:"Submitting...",
              success: function(form, action) {
                //Ext.bio.notifier.show('Sequences Renamed', 'Finished renaming seqeuneces');
                Ext.getCmp(parentComponentId).hide();
              }
            });
          }
        }
      },
      {
        text: 'Cancel',
        handler: function(){
          Ext.getCmp(parentComponentId).hide();
        }
      }
      ]
    });

    Ext.apply(this,{
      items:   form
    });
    Ext.bio.BlastCleanerWindow.superclass.initComponent.call(this);
  } ,
  setBiodatabaseId: function(biodatabaseId) {
    Ext.getCmp('biodatabase-id-clean-field').setValue(biodatabaseId);
  }
});


Ext.bio.BlastCreateDbsWindow = Ext.extend(Ext.Window,{
  title: 'Blast & Create DBs',
  layout:'fit',
  width:500,
  height:220,
  closeAction:'hide',
  plain: true,
  id:'bio-blast-window',
  initComponent: function() {
    var parentComponentId = this.id;

    var testCombo = new Ext.form.ComboBox({
      fieldLabel: 'Test Database',
      name:'biodatabase',
      id:'test-biodatabase-id-blast-field',
      hiddenName : 'test_biodatabase_id',
      valueField:'id',
      displayField:'name',
      store: this.dbStore,
      typeAhead: true,
      mode: 'local',
      triggerAction: 'all',
      emptyText:'Select a test database...',
      selectOnFocus:true,
      width: 350,
      listWidth: 350,
      allowBlank:false
    });
    var targetCombo = new Ext.form.ComboBox({
      fieldLabel: 'Target Database',
      name:'biodatabase',
      id:'target-biodatabase-id-blast-field',
      hiddenName : 'target_biodatabase_id',
      valueField:'id',
      displayField:'name',
      store: this.dbStore,
      typeAhead: true,
      mode: 'local',
      triggerAction: 'all',
      emptyText:'Select a target database...',
      selectOnFocus:true,
      width: 350,
      listWidth: 350,
      allowBlank:false
    });


    var form = new Ext.FormPanel({
      id: 'my-blast-form-panel',
      labelWidth: 120, // label settings here cascade unless overridden
      url:'/tools/blast_create_dbs.json',
      method: 'POST',
      baseParams:{
        authenticity_token: FORM_AUTH_TOKEN
      },
      frame:true,
      bodyStyle:'padding:5px 5px 0',
      defaults: {
        width: 230
      },
      defaultType: 'textfield',
      items: [testCombo, targetCombo,
      {
        fieldLabel: 'Output DB Group',
        name: 'output_biodatabase_group_name',
        allowBlank:true,
        msgTarget:'side'
      } , {
        fieldLabel: 'E-Value',
        name: 'evalue',
        value:'25',
        allowBlank:true
      }],
      buttons: [{
        text: 'Submit',
        handler: function(){
          var form = Ext.getCmp('my-blast-form-panel').getForm();
          if (form && form.isValid()) {
            form.submit({
              waitMsg:"Submitting...",
              success: function(form, action) {
                //Ext.bio.notifier.show('Sequences Renamed', 'Finished renaming seqeuneces');
                Ext.getCmp(parentComponentId).hide();
              }
            });
          }
        }
      },
      {
        text: 'Cancel',
        handler: function(){
          Ext.getCmp(parentComponentId).hide();
        }
      }
      ]
    });

    Ext.apply(this,{
      items:   form
    });
    Ext.bio.BlastCreateDbsWindow.superclass.initComponent.call(this);
  },

  setBiodatabaseId: function(biodatabaseId) {
    Ext.getCmp('test-biodatabase-id-blast-field').setValue(biodatabaseId);
    Ext.getCmp('target-biodatabase-id-blast-field').setValue(biodatabaseId);
  }
});


Ext.bio.ClustalwWindow = Ext.extend(Ext.Window,{
  title: 'ClustalW',
  layout:'fit',
  width:500,
  height:50,
  closeAction:'hide',
  plain: true,
  id: 'bio-clustalw-window',
  initComponent: function() {
    var parentComponentId = this.id;
    var combo = new Ext.form.ComboBox({
      fieldLabel: 'Database',
      name:'biodatabase',
      id: 'biodatabase-id-clustalw-field',
      hiddenName : 'biodatabase_id',
      valueField:'id',
      displayField:'name',
      store: this.dbStore,
      typeAhead: true,
      mode: 'local',
      triggerAction: 'all',
      emptyText:'Select a database...',
      selectOnFocus:true,
      width: 450,
      listWidth: 450,
      allowBlank:false
    });
    var form = new Ext.FormPanel({
      id: 'my-clustalw-form-panel',
      labelWidth: 120, // label settings here cascade unless overridden
      url:'/tools/clustalws.json',
      method: 'POST',
      baseParams:{
        authenticity_token: FORM_AUTH_TOKEN
      },
      frame:true,
      bodyStyle:'padding:5px 5px 0',
      defaults: {
        width: 450
      },
      defaultType: 'textfield',
      items: [ combo ],
      buttons: [{
        text: 'Submit',
        handler: function(){
          var form = Ext.getCmp('my-clustalw-form-panel').getForm();
          if (form && form.isValid()) {
            form.submit({
              waitMsg:"Submitting...",
              success: function(form, action) {
                //Ext.bio.notifier.show('Sequences Renamed', 'Finished renaming seqeuneces');
                Ext.getCmp(parentComponentId).hide();
              }
            });
          }
        }
      },
      {
        text: 'Cancel',
        handler: function(){
          Ext.getCmp(parentComponentId).hide();
        }
      }
      ]
    });

    Ext.apply(this,{
      items:   form
    });
    Ext.bio.ClustalwWindow.superclass.initComponent.call(this);
  } ,
  setBiodatabaseId: function(biodatabaseId) {
    Ext.getCmp('biodatabase-id-clustalw-field').setValue(biodatabaseId);
  }
});

Ext.bio._showFormWindow = function (obj, cmpId, store, biodatabaseId){
  var win  = Ext.getCmp(cmpId);
  if(!win){
    win = new obj({
      dbStore: store,
      id: cmpId
    });
  }
  win.show(this);
  if (biodatabaseId) {
    win.setBiodatabaseId(biodatabaseId);
  }

}
Ext.bio.showBiodatabaseRenamerWindow = function(biodatabaseId) {

  var cmpId = 'bio-db-renamer-window';
  var obj = Ext.bio.BiodatabaseRenamerWindow ;
  var store = Ext.workbenchdata.rawDbsComboStore;
  Ext.bio._showFormWindow(obj, cmpId, store, biodatabaseId);
}

Ext.bio.showBlastCleanerWindow = function(biodatabaseId) {
  var cmpId = 'bio-blast-cleaners-window';
  var obj = Ext.bio.BlastCleanerWindow;
  var store = Ext.workbenchdata.rawDbsComboStore;
  Ext.bio._showFormWindow(obj, cmpId, store, biodatabaseId);
}

Ext.bio.showBlastCreateDbsWindow  = function(biodatabaseId) {
  var cmpId = 'bio-blast-window';
  var obj = Ext.bio.BlastCreateDbsWindow;
  var store = Ext.workbenchdata.rawDbsComboStore;
  Ext.bio._showFormWindow(obj, cmpId, store, biodatabaseId);
}
Ext.bio.showClustalwWindow  = function(biodatabaseId) {
  var cmpId = 'bio-clustalw-window';
  var obj = Ext.bio.ClustalwWindow;
  var store =Ext.workbenchdata.generatedDbsComboStore ;
  Ext.bio._showFormWindow(obj, cmpId, store, biodatabaseId);
}