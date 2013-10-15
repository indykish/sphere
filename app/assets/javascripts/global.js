var current_user, current_organisation;
APP.init = function() {
  // Load current_user and current_organisation data
  var body = $('body');
  current_user = { id: parseInt(body.data('current-user-id')), name: body.data('current-user-name') };
  current_organisation = { id: parseInt(body.data('current-organisation-id')) };

  // Load the menu
  this.global.menuInit();
  this.global.keyboardShortcutsInit();

  // Load the feedback module
  new IADAFeedback({
    open_button_id: 'open-feedback-button',
    backend_url: Routes.feedbacks_path({ format: 'json' })
  });

  // Load stickies (if #note-container is present)
  this.stickies.loadStickies();

  // Set the upper nprogress bar as the default ajax complete and start handlers
  this.global.addProgressbarToAjax();

  // Initialize tabs
  this.global.initializeTabs();

  // Initialize date- and timepicker fields
  this.global.initializeDateTimePickers();
};

// Add progress bar for Turbolink requests
$(document).on('page:fetch', function() { NProgress.stackPush(); });
$(document).on('page:load', function() { NProgress.stackPop(); });
$(document).on('page:restore', function() { NProgress.remove(); });

APP.global = {
  menuInit: function() {
    var submenuBox = $('#submenu-box');

    this.slideSubMenuByMenuItem($('#main-menu > li.active').first().attr('id'), false);

    $('#main-menu > li > a').on('click', function() {
      return APP.global.slideSubMenuByMenuItem($(this).parent('li').attr('id'), true);
    });
  },
  addProgressbarToAjax : function() {
    NProgress.configure({ container: $('div#progress-bar-container'), showSpinner: false });

    $(document).ajaxStart(function() {
      NProgress.stackPush();
    });

    $(document).ajaxComplete(function() {
      NProgress.stackPop();
    });
  },
  slideSubMenuByMenuItem: function(htmlId, animated) {
    var submenuBox = $('#submenu-box');
    var menuItem = $('#' + htmlId);
    var relatedSubmenu = $('#submenu-box > .submenu[data-main-menu-relation="' + htmlId + '"]').first();
    var duration = animated ? 250 : 0;

    if($(submenuBox).is(':animated')) {
      return false;
    } else if (!htmlId || relatedSubmenu.length == 0 || menuItem.length == 0) {
      return true;
    } else {
      var menuItems = $('#main-menu > li');
      var submenus = $('#submenu-box > .submenu');

      $(menuItems).children('a').each(function(){
        var shortcutKey = APP.global.getShortcutKeyById($(this).data('shortcutFor'));
        if (shortcutKey) {
          var txt = $(this).text();
          var index = txt.toUpperCase().indexOf(shortcutKey);
          if (index >= 0) {
            $(this).html(txt.substring(0, index) + '<span class="shortcut-highlight">' + txt.substring(index, index + 1) + '</span>' + txt.substring(index + 1));
          }
        }
      });

      if ($(menuItem).hasClass('selected')) { /* Contract expanded submenu */
        $(menuItems).removeClass('selected');
        $(menuItems).children('a').each(function(){
          var shortcutKey = APP.global.getShortcutKeyById($(this).data('shortcutFor'));
          if (shortcutKey) {
            $(this).attr('title', jsLang.global.expand_menu + ' [Alt+' + shortcutKey + ']');
          }
        });
        $(submenuBox).animate({height: 0}, duration, 'swing', function() {
          $(submenus).removeClass('selected');
        });
      } else {
        $(menuItems).removeClass('selected');
        $(menuItems).children('a').each(function(){
          var shortcutKey = APP.global.getShortcutKeyById($(this).data('shortcutFor'));
          if (shortcutKey) {
            $(this).attr('title', jsLang.global.expand_menu + ' [Alt+' + shortcutKey + ']');
          }
        });
        $(menuItem).addClass('selected');
        $(menuItem).children('a').each(function(){
          var shortcutKey = APP.global.getShortcutKeyById($(this).data('shortcutFor'));
          if (shortcutKey) {
            $(this).attr('title', jsLang.global.contract_menu + ' [Alt+' + shortcutKey + ']');
          }
        });
        if ($(submenuBox).height() > 0) { /* Contract expanded submenu first, then expand requested submenu */
          $(submenuBox).animate({height: 0}, duration, 'swing', function() {
            $(submenus).removeClass('selected');
            $(relatedSubmenu).addClass('selected');
            $(submenuBox).animate({height: relatedSubmenu.outerHeight(false)}, duration, 'swing', function() {
              $(this).css({height: 'auto'});
            });
          });
        } else { /* Expand requested submenu */
          $(submenus).removeClass('selected');
          $(relatedSubmenu).addClass('selected');
          $(submenuBox).animate({height: relatedSubmenu.outerHeight(false)}, duration, 'swing', function(){
            $(this).css({height: 'auto'});
          });
        }
      }
      return false;
    }
  },
  keyboardShortcutsInit: function() {
    $(document).keydown(function(event) {
      if(event.altKey) {
        var keyString = String.fromCharCode(event.which);
        $('#main-menu > li > a').each(function(){
          var menuItemId = $(this).parent().attr('id');
          var menuItemShortcutKey = APP.global.getShortcutKeyById($(this).data('shortcutFor'));
          if(keyString == menuItemShortcutKey) {
            return APP.global.executeShortcut(menuItemId);
          }
        });
      }
    });
  },
  executeShortcut: function(htmlId) {
    this.slideSubMenuByMenuItem(htmlId, true);
    return false;
  },
  getShortcutKeyById: function(id) {
    var key = jsLang.shortcutKeys[id.replace(/[^a-zA-Z0-9]/g, '_')];
    if (typeof(key) != 'undefined' && key.length == 1) {
      return key.toUpperCase();
    } else {
      return false;
    }
  },
  initializeTabs: function() {
    var container = $('#tabs');
    container.tabs({ active: this.determineFirstTabWithErrors(container) });
  },
  determineFirstTabWithErrors: function(container) {
    // Determines the first tab to open. This is the first tab with errors (if any, else simply open the first tab)
    var first = 0;
    container.find('.nav a').each(function(index) {
      var id = $(this).attr('href'); // Starts with #
      var tab = container.find(id);
      if(tab.find('div.field_with_errors').length) {
        first = index
        return false; // Break
      }
    });
    return first;
  },
  initializeDateTimePickers: function(parent) {
    if(!parent) {
      parent = document.body;
    }
    $(parent).find('.datepicker-field').datepicker({ showOn: 'both' });
    $(parent).find('.timepicker-field').timepicker({ showPeriodLabels: false, showOn: 'both' });
    $(document).on('nested:fieldAdded', function() { APP.global.initializeDateTimePickers(this); });
  }
};

APP.global.nested_objects = {
  initWrapper: function(wrapper) {
    wrapper.find('.icon-edit').click(function() { APP.global.nested_objects.editWrapper(wrapper) });
    wrapper.find('.icon-ok').click(function() { APP.global.nested_objects.finishWrapper(wrapper) });

    // Fix the extra remove link work
    wrapper.find('.remove-nested-fields-extra').click(function () { $(this).closest('.fields').find('.remove_nested_fields').click(); });

    // If the option is not valid, then show form immediately. New properties are also not valid by default.
    if(wrapper.attr('data-valid') == 'false') {
      this.editWrapper(wrapper);
    }
  },
  editWrapper: function(wrapper) {
    wrapper.find('.view').hide();
    wrapper.find('.form').show();
  },
  finishWrapper: function(wrapper) {
    // Copy all data from input fields to corresponding containers in view
    wrapper.find('.view [data-field]').each(function () {
      var input = wrapper.find('.form [data-field="' + $(this).attr('data-field') + '"]');
      if(input) {
        if(input.is('select')) {
          // We are dealing with a checkbox field
          var value = (input.val() ? input.find(':selected').text() : '');
        } else if(input.is('input') && input.attr('type') == 'checkbox') {
          // We are dealing with a checkbox field
          var value = input.is(':checked') ? jsLang.global.yes : jsLang.global.no;
        } else {
          // We are dealing with a normal field
          var value = input.val();
        }
      } else {
        var value = '';
      }
      $(this).html(formatText(value));
    });
    wrapper.find('.form').hide();
    wrapper.find('.view').show();
  }
};

function arrayToSentence(array) {
  if(array.length <= 1) {
    return array
  } else {
    return array.slice(0, array.length - 1).join(', ') + jsLang.global.and + array.slice(-1);
  }
}

function formatText(text) {
  if(text == '') {
     return '<em>' + jsLang.global.none + '</em>';
  } else {
    return text;
  }
}

function openModal(modalID, content, closeCallback) {
  var closeCallback = closeCallback || this.closeModal;

  var overlay = $('a.overlay');
  overlay.on('click', closeCallback);

  var modalDiv = $('div.modal');
  modalDiv.attr('id', modalID);
  modalDiv.find('a.close').on('click', closeCallback);

  // Content toevoegen aan modal
  modalDiv.append(content);

  // Open overlay
  window.location.hash = 'modal_overlay';
  $('html').addClass('with-overlay');

  return modalDiv;
}

function closeModal(e) {
  if(e != null) {
    e.preventDefault();
  }

  var modalDiv = $('div.modal');
  modalDiv.children(':not(a.close)').remove();
  modalDiv.removeAttr('id');

  var overlay = $('a.overlay');

  $('html').removeClass('with-overlay');
  window.location.hash = 'modal_close';

  // Remove events from the overlay
  overlay.off('click');
  overlay.find('a.close').off('click');

  if(e != null) {
    return false;
  }
}

window.log = function ( string ) {
  if ( typeof console == 'object' ) { console.log ( string ) };
}

Date.prototype.customFormat = function(formatString){
    var YYYY,YY,MMMM,MMM,MM,M,DDDD,DDD,DD,D,hhh,hh,h,mm,m,ss,s,ampm,AMPM,dMod,th;
    var dateObject = this;
    YY = ((YYYY=dateObject.getFullYear())+"").slice(-2);
    MM = (M=dateObject.getMonth()+1)<10?('0'+M):M;
    MMM = $.datepicker._defaults.monthNamesShort[M-1];
    MMMM = $.datepicker._defaults.monthNames[M-1];
    DD = (D=dateObject.getDate())<10?('0'+D):D;
    DDD = $.datepicker._defaults.dayNamesShort[dateObject.getDay()];
    DDDD = $.datepicker._defaults.dayNames[dateObject.getDay()];
    th=(D>=10&&D<=20)?'th':((dMod=D%10)==1)?'st':(dMod==2)?'nd':(dMod==3)?'rd':'th';
    formatString = formatString.replace("#YYYY#",YYYY).replace("#YY#",YY).replace("#MMMM#",MMMM).replace("#MMM#",MMM).replace("#MM#",MM).replace("#M#",M).replace("#DDDD#",DDDD).replace("#DDD#",DDD).replace("#DD#",DD).replace("#D#",D).replace("#th#",th);

    h=(hhh=dateObject.getHours());
    if (h==0) h=24;
    if (h>12) h-=12;
    hh = h<10?('0'+h):h;
    AMPM=(ampm=hhh<12?'am':'pm').toUpperCase();
    mm=(m=dateObject.getMinutes())<10?('0'+m):m;
    ss=(s=dateObject.getSeconds())<10?('0'+s):s;
    return formatString.replace("#hhh#",hhh).replace("#hh#",hh).replace("#h#",h).replace("#mm#",mm).replace("#m#",m).replace("#ss#",ss).replace("#s#",s).replace("#ampm#",ampm).replace("#AMPM#",AMPM);
}

$.size = function(obj) {
  if(typeof Object.keys !== 'undefined') {
    return Object.keys(obj).length
  } else {
    var size = 0, key;
    for(key in obj) {
      if(obj.hasOwnProperty(key)) size++;
    }
    return size;
  }
}