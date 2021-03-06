/*!
 * Ext JS Library 3.0.0
 * Copyright(c) 2006-2009 Ext JS, LLC
 * licensing@extjs.com
 * http://www.extjs.com/license
 */
Ext.onReady(function(){
    Ext.QuickTips.init();

    var store = new Ext.data.ArrayStore({
        fields: ['abbr', 'state'],
        data : Ext.exampledata.states // from states.js
    });

    var tb = new Ext.Toolbar();
    tb.render('toolbar');

    // add a combobox to the toolbar
    var combo = new Ext.form.ComboBox({
        store: store,
        displayField: 'state',
        typeAhead: true,
        mode: 'local',
        triggerAction: 'all',
        emptyText:'Select a state...',
        selectOnFocus:true,
        width:135
    });
    tb.addField(combo);
    tb.doLayout();

});
