Ext.bio.ncbiDatabaseStore = new Ext.data.ArrayStore({
  fields: [ 'ncbi_database_name',  'ncbi_database_id'],
  data : [ ['NT (Nucleotide)','nt'],['NR (Proteins)', 'nr'] ]
});
Ext.bio.programStore = new Ext.data.ArrayStore({
  fields: ['program'],
  data : [ ['blastn'], ['blastp'], ['blastx'], ['psitblastn'], ['tblastn'], ['tblastx'] ]
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
      items: [
      new Ext.form.Hidden({
        name: 'biodatabase_id',
        value: 1,
        id: 'biodatabase-id-rename-field'
      }) , {
        fieldLabel: 'Database Name',
        name: 'biodatabase_name',
        value:'',
        allowBlank:true,
        id: 'biodatabase-name-rename-field'
      },
       {
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
    Ext.getCmp('biodatabase-name-rename-field').setValue(params.id);
    Ext.getCmp('biodatabase-name-rename-field').disable();
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
      items: [
      new Ext.form.Hidden({
        name: 'biodatabase_id',
        value: 1,
        id: 'biodatabase-id-clean-field'
      }) , {
        fieldLabel: 'Database Name',
        name: 'biodatabase_name',
        value:'',
        allowBlank:true,
        id: 'biodatabase-name-clean-field'
      },
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
    Ext.getCmp('biodatabase-name-clean-field').setValue(params.text);
    Ext.getCmp('biodatabase-name-clean-field').disable();
  }
});

Ext.bio.BlastCreateDbsWindow = Ext.extend(Ext.Window,{
  title: 'Blast & Create DBs',
  layout:'fit',
  width:500,
  height:350,
  closeAction:'hide',
  plain: true,
  id:'bio-blast-window',
  initComponent: function() {
    var parentComponentId = this.id;
    var programCombo = new Ext.form.ComboBox({
      store: Ext.bio.programStore,
      forceSelection: true,
      displayField:'program',
      fieldLabel: 'Program',
      name:'program',
      id:'program-blast-field',
      value:'blastn', //programStore.getAt(0).get('blastn'),
      mode: 'local',
      triggerAction: 'all',
      allowBlank: false,
      selectOnFocus:true
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
      frame:true,
      bodyStyle:'padding:5px 5px 0',
      defaults: {
        width: 230
      },
      defaultType: 'textfield',
      items: [
      programCombo, 
      new Ext.form.Hidden({
        name: 'test_biodatabase_id',
        value: 1,
        id: 'test-biodatabase-id-blast-field'
      }) , {
        fieldLabel: 'Database Name',
        name: 'biodatabase_name',
        value:'',
        allowBlank:true,
        id: 'test-biodatabase-name-blast-field'
      },
      
//      testCombo,

      targetCombo,
      {
        fieldLabel: 'Output DB Group',
        name: 'output_parent_biodatabase_name',
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
      items: [  form ],
      tbar: [ '->', {
        text: "Blast Program Help ",
        handler: function() {
          Ext.workbenchMenu.blastHelpWindow.show();
        }
      }
      ]
    });
    Ext.bio.BlastCreateDbsWindow.superclass.initComponent.call(this);

  },

  setParams: function(params) {
    Ext.getCmp('test-biodatabase-id-blast-field').setValue(params.id);
    Ext.getCmp('test-biodatabase-name-blast-field').setValue(params.text);
    Ext.getCmp('test-biodatabase-name-blast-field').disable();
    Ext.getCmp('target-biodatabase-id-blast-field').store.reload();
  //    Ext.getCmp('target-biodatabase-id-blast-field').setValue(biodatabaseId);
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
      items: [
      new Ext.form.Hidden({
        name: 'biodatabase_id',
        value: 1,
        id: 'biodatabase-id-clustalw-field'
      }) , {
        fieldLabel: 'Database Name',
        name: 'biodatabase_name',
        value:'',
        allowBlank:true,
        id: 'biodatabase-name-clustalw-field'
      }],
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
    Ext.getCmp('biodatabase-name-clustalw-field').setValue(params.text);
    Ext.getCmp('biodatabase-name-clustalw-field').disable();
  }
});

Ext.bio.BlastNrNtWindow = Ext.extend(Ext.Window,{
  title: 'Blast DB against Nr/NT',
  layout:'fit',
  width:500,
  height:320,
  closeAction:'hide',
  plain: true,
  id: 'bio-blast-nr-nt-window',
  initComponent: function() {

    var ncbiDatabaseCombo = new Ext.form.ComboBox({
      typeAhead: true,
      forceSelection: true,
      triggerAction: 'all',
      mode: 'local',
      store: Ext.bio.ncbiDatabaseStore,
      valueField: 'ncbi_database_id',
      displayField: 'ncbi_database_name',
      fieldLabel: 'NCBI Database',
      name:'ncbi_database',
      hiddenName:'ncbi_database',
      value:'nt'
    });

    var programCombo = new Ext.form.ComboBox({
      store: Ext.bio.programStore,
      forceSelection: true,
      displayField:'program',
      fieldLabel: 'Program',
      name:'program',
      id:'program-blast-field',
      value:'blastn', //programStore.getAt(0).get('blastn'),
      mode: 'local',
      triggerAction: 'all',
      allowBlank: false,
      selectOnFocus:true
    });


    var parentComponentId = this.id;
    var form = new Ext.FormPanel({
      id: 'my-blast-nr-nt-form-panel',
      labelWidth: 120, // label settings here cascade unless overridden
      url:'/tools/blast_nr_nts.json',
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
      new Ext.form.Hidden({
        name: 'biodatabase_id',
        value: 1,
        id: 'biodatabase-id-nr-nt-field'
      }) ,
      {
        fieldLabel: 'Database Name',
        name: 'biodatabase_name',
        value:'',
        allowBlank:true,
        id: 'biodatabase-name-nr-nt-field'
      },
      ncbiDatabaseCombo,
      programCombo,
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
          var form = Ext.getCmp('my-blast-nr-nt-form-panel').getForm();
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
      items:   form,
      tbar: [ '->', {
        text: "Blast Program Help ",
        handler: function() {
          Ext.workbenchMenu.blastHelpWindow.show();
        }
      }
      ]

    });
    Ext.bio.BlastNrNtWindow.superclass.initComponent.call(this);
  } ,
  setParams: function(params) {
    Ext.getCmp('biodatabase-id-nr-nt-field').setValue(params.id);
    Ext.getCmp('biodatabase-name-nr-nt-field').setValue(params.text);
    Ext.getCmp('biodatabase-name-nr-nt-field').disable();
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
    for (var i=0; i< 1; i++) {
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

Ext.bio.showBlastNrNtWindow  = function(params) {
  var cmpId = 'bio-blast-nr-nt-window' ;
  var obj = Ext.bio.BlastNrNtWindow ;
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
