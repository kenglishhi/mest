//Ext.bio.StateMultiSelect = function(config) {
//  Ext.bio.StateMultiSelect.superclass.constructor.call(this, config);
//};
//Ext.extend(Ext.bio.StateMultiSelect, Ext.form.MultiSelectField, {
//});


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
      items: [combo, {
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

    Ext.bio.StateMultiSelect = function(config) {
      Ext.bio.StateMultiSelect.superclass.constructor.call(this, config);
    };
    Ext.extend(Ext.bio.StateMultiSelect, Ext.form.MultiSelectField, {
      store: this.dbStore,
      //      store: Ext.example.Store
      valueField:'id' ,
      displayField:'name',
      fieldLabel: 'Target Database',
      id:'target-biodatabase-id-blast-field',
      hiddenName : 'target_biodatabase_ids',
      name:'biodatabase'
    //      ,
    //      mode: 'local'
    });
    var targetCombo = new Ext.bio.StateMultiSelect({
      containerHeight: 200,
      containerWidth: 200
    });

    //    var targetCombo = Ext.form.MultiSelectField({
    //      store: Ext.example.Store ,
    //      valueField:'id' ,
    //      displayField:'name' ,
    //      mode: 'local' ,
    //      fieldLabel: 'Target Database',
    //      name:'biodatabase',
    //      id:'target-biodatabase-id-blast-field',
    //      hiddenName : 'target_biodatabase_id',
    //      valueField:'id',
    //      displayField:'name',
    //      store: this.dbStore,
    //      containerHeight: 200,
    //      containerWidth: 200,
    //      store: Ext.example.Store
    //    });
    //
    //    var targetCombo = new Ext.form.ComboBox({
    //      fieldLabel: 'Target Database',
    //      name:'biodatabase',
    //      id:'target-biodatabase-id-blast-field',
    //      hiddenName : 'target_biodatabase_id',
    //      valueField:'id',
    //      displayField:'name',
    //      store: this.dbStore,
    //      typeAhead: true,
    //      mode: 'local',
    //      triggerAction: 'all',
    //      emptyText:'Select a target database...',
    //      selectOnFocus:true,
    //      width: 350,
    //      listWidth: 350,
    //      allowBlank:false
    //    });


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
  //    Ext.getCmp('target-biodatabase-id-blast-field').setValue(biodatabaseId);
  }
});
Ext.bio.GroupClustalwWindow = Ext.extend(Ext.Window,{
  title: 'ClustalW all database in Group',
  layout:'fit',
  width:550,
  height:180,
  closeAction:'hide',
  plain: true,
  id: 'bio-group-clustalw-window',
  initComponent: function() {
    var parentComponentId = this.id;
    var combo = new Ext.form.ComboBox({
      fieldLabel: 'Database Group',
      name:'biodatabase_group',
      id: 'biodatabase-group-id-clustalw-field',
      hiddenName : 'biodatabase_group_id',
      valueField:'id',
      displayField:'name',
      store: this.dbStore,
      typeAhead: true,
      mode: 'local',
      triggerAction: 'all',
      emptyText:'Select a database...',
      selectOnFocus:true,
      width: 400,
      listWidth: 400,
      allowBlank:false
    });
    var form = new Ext.FormPanel({
      id: 'my-group-clustalw-form-panel',
      labelWidth: 70, // label settings here cascade unless overridden
      url:'/tools/clustalws.json',
      method: 'POST',
      baseParams:{
        authenticity_token: FORM_AUTH_TOKEN
      },
      frame:true,
      bodyStyle:'padding:5px 5px 0',
      defaults: {
        width: 400
      },
      defaultType: 'textfield',
      items: [ combo ],
      buttons: [{
        text: 'Submit',
        handler: function(){
          var form = Ext.getCmp('my-group-clustalw-form-panel').getForm();
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
    Ext.bio.GroupClustalwWindow.superclass.initComponent.call(this);
  } ,
  setBiodatabaseId: function(biodatabaseGroupId) {
    Ext.getCmp('biodatabase-group-id-clustalw-field').setValue(biodatabaseGroupId);
  }
});



Ext.bio.ClustalwWindow = Ext.extend(Ext.Window,{
  title: 'ClustalW',
  layout:'fit',
  width:550,
  height:180,
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
      width: 400,
      listWidth: 400,
      allowBlank:false
    });
    var form = new Ext.FormPanel({
      id: 'my-clustalw-form-panel',
      labelWidth: 70, // label settings here cascade unless overridden
      url:'/tools/clustalws.json',
      method: 'POST',
      baseParams:{
        authenticity_token: FORM_AUTH_TOKEN
      },
      frame:true,
      bodyStyle:'padding:5px 5px 0',
      defaults: {
        width: 400
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

Ext.bio.BlastNtAppendWindow = Ext.extend(Ext.Window,{
  title: 'Blast DB against NT and append results',
  layout:'fit',
  width:500,
  height:220,
  closeAction:'hide',
  plain: true,
  id: 'bio-blast-nt-append-window',
  initComponent: function() {
    var parentComponentId = this.id;
    var combo = new Ext.form.ComboBox({
      fieldLabel: 'Database',
      name:'biodatabase',
      id: 'biodatabase-id-nt-append-field',
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
      id: 'my-blast-nt-append-form-panel',
      labelWidth: 120, // label settings here cascade unless overridden
      url:'/tools/blast_nt_appends.json',
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
        fieldLabel: 'E-Value',
        name: 'evalue',
        value:'25',
        allowBlank:true
      },
      {
        fieldLabel: 'No. of Results to Save',
        name: 'number_of_sequences_to_save',
        value:'10',
        allowBlank:true
      }
      ],
      buttons: [{
        text: 'Submit',
        handler: function(){
          var form = Ext.getCmp('my-blast-nt-append-form-panel').getForm();
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
    Ext.bio.BlastNtAppendWindow.superclass.initComponent.call(this);
  } ,
  setBiodatabaseId: function(biodatabaseId) {
    Ext.getCmp('biodatabase-id-nt-append-field').setValue(biodatabaseId);
  }
});

Ext.bio.BlastGroupNtAppendWindow = Ext.extend(Ext.Window,{
  title: 'Blast DB Group against NT and append results',
  layout:'fit',
  width:500,
  height:220,
  closeAction:'hide',
  plain: true,
  id: 'bio-blast-group-nt-append-window',
  initComponent: function() {
    var parentComponentId = this.id;
    var combo = new Ext.form.ComboBox({
      fieldLabel: 'Database Group',
      name:'biodatabase',
      id: 'biodatabase-group-id-nt-append-field',
      hiddenName : 'biodatabase_group_id',
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
      id: 'my-blast-group-nt-append-form-panel',
      labelWidth: 120, // label settings here cascade unless overridden
      url:'/tools/blast_group_nt_appends.json',
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
        fieldLabel: 'E-Value',
        name: 'evalue',
        value:'25',
        allowBlank:true
      },
      {
        fieldLabel: 'No. of Results to Save',
        name: 'number_of_sequences_to_save',
        value:'10',
        allowBlank:true
      }
      ],
      buttons: [{
        text: 'Submit',
        handler: function(){
          var form = Ext.getCmp('my-blast-group-nt-append-form-panel').getForm();
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
    Ext.bio.BlastNtAppendWindow.superclass.initComponent.call(this);
  } ,
  setBiodatabaseId: function(biodatabaseId) {
    Ext.getCmp('biodatabase-group-id-nt-append-field').setValue(biodatabaseId);
  }
});

Ext.bio.FastaFileUploadWindow = Ext.extend(Ext.Window,{
  title: 'Upload Fasta Files',
  layout:'fit',
  width:500,
  height:220,
  closeAction:'hide',
  plain: true,
  id:'fasta-file-upload-window',
  initComponent: function() {
    var parentComponentId = this.id;
    var fastaFileItems = [];
    for (var i=0; i< 5; i++) {
      fastaFileItems[i] = {
        xtype: 'fileuploadfield',
        id: 'fasta-file-' + i,
        emptyText: 'Select an file',
        fieldLabel: 'Fasta File',
        name: 'fasta_files[][uploaded_data]',
        buttonText: '',
        buttonCfg: {
          iconCls: 'upload-icon'
        }
      }
    }

    var form = new Ext.FormPanel({
      id: 'my-fasta-file-upload-form-panel',
      labelWidth: 75, // label settings here cascade unless overridden
      url:'/fasta_files.json',
      method: 'POST',
      fileUpload: true,
      baseParams:{
        authenticity_token: FORM_AUTH_TOKEN
      },
      frame:true,
      bodyStyle:'padding:5px 5px 0',
      defaults: {
        width: 230
      },
      defaultType: 'textfield',
      items: fastaFileItems,
      buttons: [{
        text: 'Save',
        handler: function(){
          var form = Ext.getCmp('my-fasta-file-upload-form-panel').getForm();
          if (form && form.isValid()) {
            form.submit({
              waitMsg: 'Uploading your Fasta Files...',
              success: function(form, action) {
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
    Ext.bio.FastaFileUploadWindow.superclass.initComponent.call(this);
  },
  setBiodatabaseId: function(biodatabaseId) {
    for (var i=0; i< 5; i++) {
      Ext.getCmp('fasta-file-' + i).setValue('');
    }
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

};
Ext.bio.showBiodatabaseRenamerWindow = function(biodatabaseId) {
  var cmpId = 'bio-db-renamer-window';
  var obj = Ext.bio.BiodatabaseRenamerWindow ;
  var store = Ext.workbenchdata.rawDbsComboStore;
  Ext.bio._showFormWindow(obj, cmpId, store, biodatabaseId);
};

Ext.bio.showBlastCleanerWindow = function(biodatabaseId) {
  var cmpId = 'bio-blast-cleaners-window';
  var obj = Ext.bio.BlastCleanerWindow;
  var store = Ext.workbenchdata.rawDbsComboStore;
  Ext.bio._showFormWindow(obj, cmpId, store, biodatabaseId);
} ;

Ext.bio.showBlastCreateDbsWindow  = function(biodatabaseId) {
  var cmpId = 'bio-blast-window';
  var obj = Ext.bio.BlastCreateDbsWindow;
  var store = Ext.workbenchdata.rawDbsComboStore;
  Ext.bio._showFormWindow(obj, cmpId, store, biodatabaseId);
} ;

Ext.bio.showClustalwWindow  = function(biodatabaseId) {
  var cmpId = 'bio-clustalw-window';
  var obj = Ext.bio.ClustalwWindow;
  var store =Ext.workbenchdata.generatedDbsComboStore ;
  Ext.bio._showFormWindow(obj, cmpId, store, biodatabaseId);
} ;

Ext.bio.showGroupClustalwWindow  = function(biodatabaseGroupId) {
  var cmpId = 'bio-group-clustalw-window';
  var obj = Ext.bio.GroupClustalwWindow;
  var store = Ext.workbenchdata.biodatabaseGroupsComboStore ;
  Ext.bio._showFormWindow(obj, cmpId, store, biodatabaseGroupId);
} ;

Ext.bio.showBlastNtAppendWindow  = function(biodatabaseId) {
  var cmpId = 'bio-blast-nt-append-window' ;
  var obj = Ext.bio.BlastNtAppendWindow ;
  var store = Ext.workbenchdata.generatedDbsComboStore ;
  Ext.bio._showFormWindow(obj, cmpId, store, biodatabaseId);
};

Ext.bio.showBlastGroupNtAppendWindow  = function(biodatabaseId) {
  var cmpId = 'bio-blast-group-nt-append-window';
  var obj = Ext.bio.BlastGroupNtAppendWindow ;
  var store = Ext.workbenchdata.biodatabaseGroupsComboStore ;
  Ext.bio._showFormWindow(obj, cmpId, store, biodatabaseId);
};

Ext.bio.showFastaFileUploadWindow = function(biodatabaseId) {
  var cmpId = 'fasta-file-upload-create--window';
  var obj = Ext.bio.FastaFileUploadWindow ;
  //  var store = Ext.workbenchdata.biodatabaseGroupsComboStore ;
  var store = null;
  Ext.bio._showFormWindow(obj, cmpId, store, biodatabaseId);
};
