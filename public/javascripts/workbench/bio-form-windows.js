Ext.bio.blastProgramStore = new Ext.data.SimpleStore({
  fields: ['program'],
  data : [ ['blastn'], ['blastp'], ['blastx'], ['psitblastn'], ['tblastn'], ['tblastx'] ]
});

Ext.bio.ncbiDatabaseStore = new Ext.data.SimpleStore({
  fields: ['ncbi_database','ncbi_database_name'],
  data : [ ['nr', "NR (Proteins)"], ['nt', "NT (Nucleotides)"] ]
});
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
      forceSelection:true,
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
  setParams: function(params) {
    Ext.getCmp('biodatabase-id-rename-field').setValue(params.id);
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
        fieldLabel: 'Clean Database Name',
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
  setParams: function(params) {
    Ext.getCmp('biodatabase-id-clean-field').setValue(params.id);
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
    var programCombo = new Ext.form.ComboBox({
      store: Ext.bio.blastProgramStore,
      forceSelection: true,
      displayField:'program',
      fieldLabel: 'Program',
      name:'program',
      id:'program-blast-field',
      value:'blastn', //blastProgramStore.getAt(0).get('blastn'),
      mode: 'local',
      triggerAction: 'all',
      allowBlank: false,
      selectOnFocus:true

    });



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

    var form = new Ext.FormPanel({
      id: 'my-blast-form-panel',
      labelWidth: 120, // label settings here cascade unless overridden
      url:'/tools/blast_create_dbs.json',
      method: 'POST',
      baseParams:{
        authenticity_token: FORM_AUTH_TOKEN
      },
      tbar: [ '->', {
        text: "Blast Program Help ",
        handler: function() {
          Ext.workbenchMenu.blastHelpWindow.show();
        }
      }
      ],
      frame:true,
      bodyStyle:'padding:5px 5px 0',
      defaults: {
        width: 230
      },
      defaultType: 'textfield',
      items: [
      programCombo, testCombo, targetCombo,
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
      },{
        fieldLabel: 'Coverage',
        name: 'coverage',
        value:'',
        allowBlank:true
      },{
        fieldLabel: 'Score',
        name: 'score',
        value:'',
        allowBlank:true
      }
      ],
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
      items: [  form ]
    });
    Ext.bio.BlastCreateDbsWindow.superclass.initComponent.call(this);

  },

  setParams: function(params) {
    Ext.getCmp('test-biodatabase-id-blast-field').setValue(params.id);
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
  setParams: function(params) {
    Ext.getCmp('biodatabase-group-id-clustalw-field').setValue(params.id);
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
      forceSelection:true,
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
  setParams: function(params) {
    Ext.getCmp('biodatabase-id-clustalw-field').setValue(params.id);
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
    var programCombo = new Ext.form.ComboBox({
      store: Ext.bio.blastProgramStore,
      forceSelection: true,
      displayField:'program',
      fieldLabel: 'Program',
      name:'program',
      id:'program-blast-field',
      value:'blastn', //blastProgramStore.getAt(0).get('blastn'),
      mode: 'local',
      triggerAction: 'all',
      allowBlank: false,
      selectOnFocus:true

    });

    var ncbiCombo = new Ext.form.ComboBox({
      store: Ext.bio.ncbiDatabaseStore,
      forceSelection: true,
      displayField:'ncbi_database_name',
      valueField:'ncbi_database',
      fieldLabel: 'NCBI Database',
      name:'ncbi_database',
      id:'ncbi-database-blast-field',
      mode: 'local',
      value: 'nt',
      triggerAction: 'all',
      allowBlank: false,
      selectOnFocus:true

    });


    var parentComponentId = this.id;
    var form = new Ext.FormPanel({
      id: 'my-blast-nt-append-form-panel',
      labelWidth: 150, // label settings here cascade unless overridden
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
      items: [
       {
        fieldLabel: 'Database',
        name: 'database_name',
        disabled: true,
        width: 300,
        id: 'biodatabase-name-nt-append-field',
        value:'',
        allowBlank:true
      },
        programCombo, ncbiCombo,
      new Ext.form.Hidden({
        name: 'biodatabase_id',
        id: 'biodatabase-id-nt-append-field',
        value: '20002'
      }) ,
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
  setParams: function(params) {
    Ext.getCmp('biodatabase-id-nt-append-field').setValue(params.id);
    Ext.getCmp('biodatabase-name-nt-append-field').setValue(params.text) ;
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
        text: 'Upload',
        handler: function(){
          var form = Ext.getCmp('my-fasta-file-upload-form-panel').getForm();
          if (form && form.isValid()) {
            form.submit({
              waitMsg: 'Uploading your Fasta Files...',
              success: function(form, action) {
                var win = Ext.getCmp(parentComponentId);
                win.hide();
                if ( Ext.bio.workbench.afterUploadFasta) {
                  Ext.bio.workbench.afterUploadFasta();
                }
              }
            });
          }
        }
      },
      {
        text: 'Cancel',
        handler: function(){
          var win = Ext.getCmp(parentComponentId);
          win.hide();
        }
      }
      ]
    });

    Ext.apply(this,{
      items:   form
    });
    Ext.bio.FastaFileUploadWindow.superclass.initComponent.call(this);
  },
  setParams: function(fastaGridCmpId) {
    for (var i=0; i< 5; i++) {
      var cmp = Ext.getCmp('fasta-file-' + i);
      if (cmp) {
        cmp.setValue('');
      }
    }
    this.fastaGridCmpId = fastaGridCmpId ;
  }
});

Ext.bio.ExtractSequencesWindow = Ext.extend(Ext.Window,{
  title: 'Extract Sequences',
  layout:'fit',
  width:500,
  height:120,
  closeAction:'hide',
  plain: true,
  id: 'bio-extract-sequences-window',
  fastaFileId:null,
  initComponent: function() {

    var form = new Ext.FormPanel({
      parentComponentId: this.id,
      id: 'my-extract-sequences-form-panel',
      labelWidth: 120, // label settings here cascade unless overridden
      url:'/tools/extract_sequences.json',
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
      items: [
      {
        id: 'extract-sequences-biodatabase-name-field',
        fieldLabel: 'New Database Name',
        name: 'new_biodatabase_name',
        allowBlank:true,
        msgTarget:'side'
      }
      ],
      buttons: [{
        text: 'Submit',
        parentComponentId: this.id,
        handler: function() {
          Ext.getCmp(this.parentComponentId).hide();
          var form = Ext.getCmp('my-extract-sequences-form-panel').getForm();
          if (form && form.isValid()) {
            form.baseParams.fasta_file_id = Ext.getCmp(this.parentComponentId).fastaFileId;
            form.submit({
              waitMsg:"Submitting...",
              success: function(form, action) {
                //Ext.bio.notifier.show('Sequences Renamed', 'Finished renaming seqeuneces');
                Ext.getCmp(form.parentComponentId).hide();
              }
            });
          }
        }
      },
      {
        text: 'Cancel',
        parentComponentId: this.id,
        handler: function(){
          Ext.getCmp(this.parentComponentId).hide();
        }
      }
      ]
    });

    Ext.apply(this,{
      items:   form
    });
    Ext.bio.BlastCleanerWindow.superclass.initComponent.call(this);
  } ,
  setParams: function(params) {
    this.setTitle("Extract Sequences from '" + params.text + "'");
    this.fastaFileId = params.id;
    //    Ext.getCmp('biodatabase-id-clean-field').setValue(biodatabaseId);
    Ext.getCmp('extract-sequences-biodatabase-name-field').setValue(params.text );
  }
});


Ext.bio._showFormWindow = function (obj, cmpId, store, params){
  var win  = Ext.getCmp(cmpId);
  if(!win){
    win = new obj({
      dbStore: store,
      id: cmpId
    });
  }
  win.show(this);
  if (params) {
    win.setParams(params);
  }
};
Ext.bio.showBiodatabaseRenamerWindow = function(params) {
  var cmpId = 'bio-db-renamer-window';
  var obj = Ext.bio.BiodatabaseRenamerWindow ;
  var store = Ext.workbenchdata.rawDbsComboStore;
  Ext.bio._showFormWindow(obj, cmpId, store, params);
};

Ext.bio.showBlastCleanerWindow = function(params) {
  var cmpId = 'bio-blast-cleaners-window';
  var obj = Ext.bio.BlastCleanerWindow;
  var store = Ext.workbenchdata.rawDbsComboStore;
  Ext.bio._showFormWindow(obj, cmpId, store, params);
} ;

Ext.bio.showBlastCreateDbsWindow  = function(params) {
  var cmpId = 'bio-blast-window';
  var obj = Ext.bio.BlastCreateDbsWindow;
  var store = Ext.workbenchdata.rawDbsComboStore;
  Ext.bio._showFormWindow(obj, cmpId, store, params);
} ;

Ext.bio.showClustalwWindow  = function(params) {
  var cmpId = 'bio-clustalw-window';
  var obj = Ext.bio.ClustalwWindow;
  var store;// = Ext.workbenchdata.generatedDbsComboStore ;
  if (params.attributes.db_type == "Database Group") { 
    store = Ext.workbenchdata.groupDbsComboStore ;
  } else  {
    store = Ext.workbenchdata.generatedDbsComboStore ;
  }
  Ext.bio._showFormWindow(obj, cmpId, store, params);
} ;

Ext.bio.showBlastNtAppendWindow  = function(params) {
  var cmpId = 'bio-blast-nt-append-window' ;
  var obj = Ext.bio.BlastNtAppendWindow ;
  var store = null;
  Ext.bio._showFormWindow(obj, cmpId, store, params);
};

Ext.bio.showFastaFileUploadWindow = function(params) {
  var cmpId = 'fasta-file-upload-create-window';
  var obj = Ext.bio.FastaFileUploadWindow ;
  var store = null;
  Ext.bio._showFormWindow(obj, cmpId, store);
};

Ext.bio.showExtractSequencesWindow = function(params) {
  var cmpId = 'fasta-file-extract-sequences-window';
  var obj = Ext.bio.ExtractSequencesWindow ;
  //  var store = Ext.workbenchdata.biodatabaseGroupsComboStore ;
  var store = null;
  Ext.bio._showFormWindow(obj, cmpId, store,params);
};
