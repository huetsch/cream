(function() {
  var blues_strftime,
    __hasProp = Object.prototype.hasOwnProperty,
    __slice = Array.prototype.slice;

  Object["delete"] = function(obj, k) {
    var v;
    v = obj[k];
    delete obj[k];
    return v;
  };

  Object.clone = function(obj) {
    var key, newInstance;
    if (!(obj != null) || typeof obj !== 'object') return obj;
    newInstance = new obj.constructor();
    for (key in obj) {
      newInstance[key] = Object.clone(obj[key]);
    }
    return newInstance;
  };

  Object.merge = function(o1, o2) {
    var k, v;
    o1 = Object.clone(o1);
    for (k in o2) {
      if (!__hasProp.call(o2, k)) continue;
      v = o2[k];
      o1[k] = v;
    }
    return o1;
  };

  Object.update = function(o1, o2) {
    var k, v;
    for (k in o2) {
      if (!__hasProp.call(o2, k)) continue;
      v = o2[k];
      o1[k] = v;
    }
    return o1;
  };

  Object.toArray = function(obj) {
    var k, v, _results;
    _results = [];
    for (k in obj) {
      if (!__hasProp.call(obj, k)) continue;
      v = obj[k];
      _results.push([k, v]);
    }
    return _results;
  };

  Object.isPlainObject = function(obj) {
    return (obj && (typeof obj === 'object') && (Object.getPrototypeOf(obj) === Object.prototype) && (Object.prototype.toString.call(obj) === {}.toString())) || false;
  };

  Array.wrap = function(obj) {
    if (obj instanceof Array) {
      return obj;
    } else if (obj === null || obj === void 0) {
      return [];
    } else {
      return [obj];
    }
  };

  Array.prototype.sum = function() {
    if (this.length > 0) {
      return this.reduce(function(x, y) {
        return x + y;
      });
    } else {
      return 0;
    }
  };

  Array.prototype.first = function() {
    if (this.length > 0) {
      return this[0];
    } else {
      return;
    }
  };

  Array.prototype.last = function() {
    if (this.length > 0) return this[this.length - 1];
  };

  Array.prototype.butLast = function() {
    if (this.length > 0) return this.slice(0, -1);
  };

  Array.prototype.max = function() {
    return Math.max.apply(Math, this);
  };

  Array.prototype.min = function() {
    return Math.min.apply(Math, this);
  };

  Array.prototype.zip = function() {
    var arr, arrs, group, i, max_len, ret, _i, _len;
    arrs = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
    arrs = [Object.clone(this)].concat(arrs);
    max_len = arrs.map(function(arr) {
      return arr.length;
    }).max();
    ret = [];
    for (i = 0; 0 <= max_len ? i < max_len : i > max_len; 0 <= max_len ? i++ : i--) {
      group = [];
      for (_i = 0, _len = arrs.length; _i < _len; _i++) {
        arr = arrs[_i];
        group.push(arr[i]);
      }
      ret.push(group);
    }
    return ret;
  };

  Array.prototype.flatten = function() {
    return this.reduce((function(xs, el) {
      if (Array.isArray(el)) {
        return xs.concat(el.flatten());
      } else {
        return xs.concat([el]);
      }
    }), []);
  };

  Array.prototype.select = Array.prototype.filter;

  Array.prototype.reject = function(fn) {
    return this.select(function(x) {
      return !fn(x);
    });
  };

  Array.prototype.compact = function() {
    return this.reject(function(x) {
      return x === void 0 || x === null;
    });
  };

  Array.prototype.extract_options = function() {
    if (Object.isPlainObject(this.last())) {
      return this.pop();
    } else {
      return {};
    }
  };

  String.prototype.capitalize = function() {
    return (this.split(' ').map(function(word) {
      return word[0].toUpperCase() + word.slice(1).toLowerCase();
    })).join(' ');
  };

  String.prototype.beginsWith = function(str) {
    if (this.match(new RegExp("^" + str))) {
      return true;
    } else {
      return false;
    }
  };

  String.prototype.endsWith = function(str) {
    if (this.match(new RegExp("" + str + "$"))) {
      return true;
    } else {
      return false;
    }
  };

  String.prototype.dasherize = function(reg) {
    if (reg == null) reg = /_/g;
    if (typeof reg === 'string') reg = new RegExp(reg, 'g');
    return this.replace(reg, '-');
  };

  String.prototype.strip = String.prototype.trim;

  String.prototype.html_safe = function() {
    this.is_html_safe = 1;
    return this;
  };

  Number.prototype.seconds = function() {
    return this * 1000;
  };

  Number.prototype.minutes = function() {
    return this.seconds() * 60;
  };

  Number.prototype.minute = Number.prototype.minutes;

  Number.prototype.hours = function() {
    return this.minutes() * 60;
  };

  Number.prototype.hour = Number.prototype.hours;

  Number.prototype.ago = function() {
    return new Date(new Date().valueOf() - this);
  };

  Number.prototype.from_now = function() {
    return new Date(new Date().valueOf() + this);
  };

  Date.COMMON_YEAR_DAYS_IN_MONTH = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

  Date.is_gregorian_leap_year = function(y) {
    return y % 4 === 0 && y % 100 !== 0 || y % 400 === 0;
  };

  Date.prototype.days_in_month = function() {
    if (this.getMonth() === 1 && Date.is_gregorian_leap_year(this.getFullYear())) {
      return 29;
    } else {
      return Date.COMMON_YEAR_DAYS_IN_MONTH[this.getMonth()];
    }
  };

  Date.prototype.tomorrow = function() {
    return new Date(this.valueOf() + 24 * 60 * 60 * 1000);
  };

  Date.prototype.yesterday = function() {
    return new Date(this.valueOf() - 24 * 60 * 60 * 1000);
  };

  Date.prototype.beginning_of_day = function() {
    return new Date(new Date(this).setHours(0, 0, 0, 0));
  };

  Date.prototype.end_of_day = function() {
    return new Date(new Date(this).setHours(23, 59, 59, 999));
  };

  Date.prototype.prev_month = function() {
    var d, d2, num_days_in_prev_month;
    d = new Date(this);
    d2 = d.beginning_of_month();
    d2.setMonth(this.getMonth() - 1);
    num_days_in_prev_month = d2.days_in_month();
    if (num_days_in_prev_month < d.getDate()) d.setDate(num_days_in_prev_month);
    d.setMonth(this.getMonth() - 1);
    return d;
  };

  Date.prototype.next_month = function() {
    var d, d2, num_days_in_next_month;
    d = new Date(this);
    d2 = d.beginning_of_month();
    d2.setMonth(this.getMonth() + 1);
    num_days_in_next_month = d2.days_in_month();
    if (num_days_in_next_month < d.getDate()) d.setDate(num_days_in_next_month);
    d.setMonth(this.getMonth() + 1);
    return d;
  };

  Date.prototype.beginning_of_month = function() {
    return new Date(new Date(this).setDate(1)).beginning_of_day();
  };

  Date.prototype.end_of_month = function() {
    var last_date;
    last_date = this.days_in_month();
    return new Date(new Date(this).setDate(last_date)).end_of_day();
  };

  blues_strftime = require('prettydate').strftime;

  Date.prototype.strftime = function(str) {
    return blues_strftime(this, str);
  };

}).call(this);
