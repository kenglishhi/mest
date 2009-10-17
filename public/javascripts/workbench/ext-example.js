/*!
 * Ext JS Library 3.0.0
 * Copyright(c) 2006-2009 Ext JS, LLC
 * licensing@extjs.com
 * http://www.extjs.com/license
 */
Ext.bio.notifier = function(){
  var msgCt;
  var click = false;

  function getSlide() {
    if( !click) {
      Ext.get("slide").slideIn('t', {
        duration: .5,
        remove: false,
        useDisplay: true,
      });
      click = true;
    } else {
      if (click) {
        Ext.get("slide").slideOut('t', {
          duration: .5,
          remove: false,
          useDisplay: true,
        });
        click = false;
      }
    }
  }


  function createBox(t, s){
    return ['<div class="msg">',
    '<div class="x-box-tl"><div class="x-box-tr"><div class="x-box-tc"></div></div></div>',
    '<div class="x-box-ml"><div class="x-box-mr"><div class="x-box-mc"><h3>', t, '</h3>', s,

    '<br/><a href ="#" onclick="Ext.bio.notifier.hide();">Close</a>',
    '</div></div></div>',
    '<div class="x-box-bl"><div class="x-box-br"><div class="x-box-bc"></div></div></div>',

    '</div>'].join('');
  }
  return {
    show: function(title, format) {
      if(!Ext.get("msg-div")){
        msgCt = Ext.DomHelper.insertFirst(document.body, {
          id:'msg-div'
        }, true);
      }

     var html = createBox(title, format);
      Ext.get("msg-div").update(html);
      Ext.get("msg-div").slideIn('t', {
        duration: .5,
        remove: false,
        useDisplay: true,
      });
    },
    hide: function() {
      Ext.get("msg-div").slideOut('t', {
        duration: .5,
        remove: false,
        useDisplay: true,
      });

    }
  }
}();

//Ext.bio.notifier.show(t,s) {
//
//}

Ext.example = function(){
  var msgCt;
  function createBox(t, s){
    return ['<div class="msg">',
    '<div class="x-box-tl"><div class="x-box-tr"><div class="x-box-tc"></div></div></div>',
    '<div class="x-box-ml"><div class="x-box-mr"><div class="x-box-mc"><h3>', t, '</h3>', s, '</div></div></div>',
    '<div class="x-box-bl"><div class="x-box-br"><div class="x-box-bc"></div></div></div>',
    '</div>'].join('');
  }

  return {
    msg : function(title, format){
      if(!msgCt){
        msgCt = Ext.DomHelper.insertFirst(document.body, {
          id:'msg-div'
        }, true);
      }
      msgCt.alignTo(document, 't-t');
      var s = String.format.apply(String, Array.prototype.slice.call(arguments, 1));
      var m = Ext.DomHelper.append(msgCt, {
        html:createBox(title, s)
      }, true);
      m.slideIn('t');//.pause(1).slideIn("t", {remove:true});
    },
    hide: function(){
      msgCt.slideOut('t',{
        remove:true
      });
    }

  };
}();


//Ext.onReady(Ext.example.init, Ext.example);