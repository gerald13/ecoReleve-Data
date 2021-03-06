define(['marionette', 'lyt-rootview', 'router', 'controller',
  //circular dependencies, I don't konw where to put it 4 the moment
  'ns_modules/ns_bbfe/bbfe-number',
  'ns_modules/ns_bbfe/bbfe-timePicker',
  'ns_modules/ns_bbfe/bbfe-dateTimePicker',
  'ns_modules/ns_bbfe/bbfe-autocomplete',
  'ns_modules/ns_bbfe/bbfe-objectPicker/bbfe-objectPicker',
  'ns_modules/ns_bbfe/bbfe-objectPicker/bbfe-nonIdPicker',
  'ns_modules/ns_bbfe/bbfe-listOfNestedModel/bbfe-listOfNestedModel',
  'ns_modules/ns_bbfe/bbfe-gridForm',
  'ns_modules/ns_bbfe/bbfe-autocompTree',
  'ns_modules/ns_bbfe/bbfe-fileUpload',
  'ns_modules/ns_bbfe/bbfe-select',
  'ns_modules/ns_bbfe/bbfe-gridForm',
  'ns_modules/ns_bbfe/bbfe-ajaxButton',
  'ns_modules/ns_bbfe/bbfe-lon',
  'ns_modules/ns_bbfe/bbfe-lat',
  'ns_modules/ns_cell/bg-timestampCell',
  ],
function( Marionette, LytRootView, Router, Controller) {

  var app = {};
  var JST = window.JST = window.JST || {};
  window.xhrPool = [];


  Backbone.Marionette.Renderer.render = function(template, data) {
    if (!JST[template]) throw 'Template \'' + template + '\' not found!';
    return JST[template](data);
  };

  app = new Marionette.Application();
  app.on('start', function() {
    app.rootView = new LytRootView();
    app.controller = new Controller();
    app.router = new Router({controller: app.controller});
    app.rootView.render();
    Backbone.history.start();
  });


  $(window).ajaxStart(function(e) {
    $('#header-loader').removeClass('hidden');
  });
  $(window).ajaxStop(function() {
    $('#header-loader').addClass('hidden');
  });
  $(window).ajaxError(function() {
    $('#header-loader').addClass('hidden');
  });
  $(document).ajaxSend(function(e, xhr, opt){
    console.log('appel ajax en cours');
    window.xhrPool.push(xhr);
  });
  window.onerror = function() {
    $('#header-loader').addClass('hidden');
  };

  window.app = app;
  return app;
});
