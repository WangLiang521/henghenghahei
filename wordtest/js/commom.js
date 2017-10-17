/// <reference path="main.js" />
/// <reference path="../../lib/jquery/jquery-1.11.1.min.js" />
//配置
var sysConfig = {
    title: "优行教育管理平台",
    "defaultCity": "山东/济南",
    "pageSize": "20",//每次请求多少条数数据
    gridConfig: {
        imgPath: "lib/imgs/",
        skin: "dhx_terrace"
    },
    "Debug": true,
    "AutoLoad": false,
};



var browser={
    versions:function(){
        var u = navigator.userAgent, app = navigator.appVersion;
        return {
            trident: u.indexOf('Trident') > -1, //IE内核
            presto: u.indexOf('Presto') > -1, //opera内核
            webKit: u.indexOf('AppleWebKit') > -1, //苹果、谷歌内核
            gecko: u.indexOf('Gecko') > -1 && u.indexOf('KHTML') == -1,//火狐内核
            mobile: !!u.match(/AppleWebKit.*Mobile.*/), //是否为移动终端
            ios: !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/), //ios终端
            android: u.indexOf('Android') > -1 || u.indexOf('Adr') > -1, //android终端
            iPhone: u.indexOf('iPhone') > -1 , //是否为iPhone或者QQHD浏览器
            iPad: u.indexOf('iPad') > -1, //是否iPad
            webApp: u.indexOf('Safari') == -1, //是否web应该程序，没有头部与底部
            weixin: u.indexOf('MicroMessenger') > -1, //是否微信 （2015-01-22新增）
            qq: u.match(/\sQQ/i) == " qq" //是否QQ
        };
    }(),
    language:(navigator.browserLanguage || navigator.language).toLowerCase()
}









//全局静态变量
var sysStatic = {
    LoadType: {
        "laod": 1,
        "refresh": 2,
        "loadMore": 3,
        "loop": 4
    },
    YESNO: {
        "YES": 1,
        "NO": 0,
        "NONE": -1
    }

};
//错误类型
var sysErrorType = {
    "GridDivIDNotNull": "表格ID未配置",
    "GridHeaderNotNull": "表格标题未配置",
    "GridColTypeNotNull": "表格列类型未配置",

};

//返回顶部
function sysScollTop() {
    this.b = function () {
        h = $(window).height() - 500,
        t = $(document).scrollTop(),
        t > h ? $("#moquu_top").show() : $("#moquu_top").hide()
    }
    this.n = function () {
        if ($(this).scrollTop() > 58) {
            $(".templatemo-nav").addClass("sticky")
        } else {
            $(".templatemo-nav").removeClass("sticky")
        }
    }

    this.init = function () {
        var that = this;

        $(window).scroll(function () {
            that.b(),
            that.n()
        });

        that.b(),
        that.n();
    }

    $("#moquu_top").click(function () {
        $(document).scrollTop(0);
    });

}

//全局方法
function _sysCommon() {
    var that = this;
    //获取URL参数
    this.getUrlParam = function (name) {
        var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)"); //构造一个含有目标参数的正则表达式对象
        var r = window.location.search.substr(1).match(reg);  //匹配目标参数
        if (r != null) return unescape(r[2]); return null; //返回参数值
    }
    //ajax
    this.ajax = function (args, url, fn) {
        try {
            $.ajax({
                type: "post",
                async: true,
                data: args,
                url: url,
                dataType: "json",
                success: function (data) {

                    try {
                        if (0 == data.status && "notLogin" == data.type) {
                            //that.showAlert("对对对");
                            //that.
                            that.showErrorMsg(result);
                            that.location.href = sysURL.login;//返回登录页面
                            return;
                        }
                    } catch (e) {
                        that.location.href = sysURL.login;//返回登录页面
                    }

                    fn(data);
                },
                error: function (xml, error, exception) {
                    that.showAlert(xml.status + ":" + xml.readyState + ":" + error + ":" + exception);
                    //if (200 == xml.status && exception.message.indexOf("Unexpected token") > -1) {
                    //    that.showAlert("登录超时，请重新登录");
                    //    setTimeout(function () {
                    //        sysCommon.SetErroLoginCookie();//处理登录失败时cookie
                    //        //if (localStorage.getItem("access_token")) {
                    //        //    localStorage.removeItem("access_token");
                    //        //}
                    //        //if (localStorage.getItem("isSaveCookie")) {
                    //        //    if (!localStorage.isSaveCookie) {
                    //        //        localStorage.clear();
                    //        //    }
                    //        //} else {
                    //        //    localStorage.clear();
                    //        //}
                    //        window.location.href = sysURL.login;
                    //    }, 1000);
                    //}
                    //else {
                    //    that.showAlert(xml.status + ":" + xml.readyState + ":" + error + ":" + exception);
                    //}
                }
            });
        } catch (e) {
            that.showAlert(e.message);
        }

    }
    //登录失败处理cookie
    this.SetErroLoginCookie = function () {
        if (sysCookie.CheckCookie("adminAccess_token")) {
            sysCookie.DeleteCookie("adminAccess_token");
        }
        if (sysCookie.CheckCookie("isSaveCookie") && 1 == sysCookie.GetCookie("isSaveCookie")) {
            //保存用户名密码
        } else {
            //清楚cookie
            sysCookie.ClearCookie();
        }
    }

    //alert
    this.showAlert = function (message) {
        layer.msg(message);
    }
    //成功信息
    this.showSuccess = function (message) {
        layer.msg(message, { icon: 1, skin: 'layui-layer-molv' });//对号
    }
    //错误信息
    this.showError = function (message) {
        layer.msg(message, { icon: 5, shift: 6, skin: 'layui-layer-molv' });//哭脸
    }
    //提示信息
    this.showInfo = function (message) {
        layer.msg(message, { icon: 7, skin: 'layui-layer-molv' });//叹号
    }
    //confim
    this.showConfim = function (message, callback, cancelCallback) {
        layer.confirm(message, { icon: 3, title: '提示' }, function (index) { if (true == that.exeFunction(callback)) { layer.close(index); } }, function () { that.exeFunction(cancelCallback); });
    }

    //弹出iframe
    this.PopWindow = function (url, title, size, cancelCallback, externalfunction) {
        var area = { w: $(window).width() - 30 + "px", h: $(window).height() - 30 + "px" };
        if (!that.isNull(size)) {
            area.w = size.width
            area.h = size.height;
        }
        //iframe窗
        return layer.open({
            type: 1,
            title: title,
            closeBtn: true,
            //shade: [0],
            shadeClose: true,
            shade: false,
            maxmin: false, //开启最大化最小化按钮
            area: [area.w, area.h],
            content: url,
            success: function () {//层弹出后的成功回调方法
                that.exeFunction(externalfunction);
            },
            yes: function (index, layero) {//该回调携带两个参数，分别为当前层索引、当前层DOM对象
                //do something
                //如果设定了yes回调，需进行手工关闭
                if (false == that.exeFunction(cancelCallback)) {
                    return false;
                } else {
                    layer.close(index);
                }
            },
            cancel: function (index) {//该回调同样只携带当前层索引一个参数，无需进行手工关闭。如果不想关闭，return false即可，如 cancel: function(index){ return false; } 则不会关闭；
                if (false == that.exeFunction(cancelCallback)) {
                    return false;
                } else {
                    layer.close(index);
                }
            }
        });

        //layer.open({
        //    type: 2,
        //    title: false,
        //    closeBtn: 0, //不显示关闭按钮
        //    shade: [0],
        //    area: ['340px', '215px'],
        //    offset: 'auto', // 
        //    time: 2000, //2秒后自动关闭
        //    shift: 2,
        //    content: ['test/guodu.html', 'no'], //iframe的url，no代表不显示滚动条
        //    end: function () { //此处用于演示
        //        layer.open({
        //            type: 2,
        //            title: title,
        //            shadeClose: true,
        //            shade: false,
        //            maxmin: true, //开启最大化最小化按钮
        //            area: [area.w, area.h],
        //            content: url
        //        });
        //    }
        //});
    }
    //弹出内容
    this.PopContent = function (content, size, cancelCallback, externalfunction) {
        var area = { w: $(window).width() / 2 + "px", h: $(window).height() / 3 * 2 + "px" };
        if (!that.isNull(size)) {
            area.w = size.width
            area.h = size.height;
        }
        return layer.open({
            type: 1,
            title: false,
            closeBtn: true,
            area: [area.w, area.h],
            //skin: 'layui-layer-nobg', //没有背景色
            shadeClose: true,
            content: content,
            success: function () {//层弹出后的成功回调方法
                that.exeFunction(externalfunction);
            },
            yes: function (index, layero) {//该回调携带两个参数，分别为当前层索引、当前层DOM对象
                //do something
                //如果设定了yes回调，需进行手工关闭
                if (false == that.exeFunction(cancelCallback)) {
                    return false;
                } else {
                    layer.close(index);
                }
            },
            cancel: function (index) {//该回调同样只携带当前层索引一个参数，无需进行手工关闭。如果不想关闭，return false即可，如 cancel: function(index){ return false; } 则不会关闭；
                if (false == that.exeFunction(cancelCallback)) {
                    return false;
                } else {
                    layer.close(index);
                }
            }
        });

        //var area = { w: $(window).width() - 30 + "px", h: $(window).height() - 30 + "px" };
        //if (!that.isNull(size)) {
        //    area.w = size.width
        //    area.h = size.height;
        //}
        ////iframe窗
        //layer.open({
        //    type: 1,
        //    title: false,           
        //    shadeClose: true,
        //    //shade: false,
        //    maxmin: false, //开启最大化最小化按钮

        //    content: url,
        //    success: function () {//层弹出后的成功回调方法
        //        that.exeFunction(externalfunction);
        //    },
        //    yes: function (index, layero) {//该回调携带两个参数，分别为当前层索引、当前层DOM对象
        //        //do something
        //        //如果设定了yes回调，需进行手工关闭
        //        if (false == that.exeFunction(cancelCallback)) {
        //            return false;
        //        } else {
        //            layer.close(index);
        //        }
        //    },
        //    cancel: function (index) {//该回调同样只携带当前层索引一个参数，无需进行手工关闭。如果不想关闭，return false即可，如 cancel: function(index){ return false; } 则不会关闭；
        //        if (false == that.exeFunction(cancelCallback)) {
        //            return false;
        //        } else {
        //            layer.close(index);
        //        }
        //    }
        //});

    }

    this.ClosePop = function (obj) {
        layer.close(obj);
    }

    //判断是否是整型
    this.isInt = function (obj) {
        if ("int" == typeof (obj)) {
            return true;
        } else {
            return false;
        }
    }
    //判断是否为空 为空返回true
    this.isNull = function (obj) {
        if (null == obj || undefined == obj || "" == obj || "undefined" == obj || "undefined" == typeof (obj) || "null" == obj) {
            return true;
        } else {
            return false;
        }
    }
    //判断是否为空  不为空返回true
    this.isNotNull = function (obj) {
        if (that.isNull(obj)) {
            return false;
        } else {
            return true;
        }
    }
    //获取友好字符串（如果是null或者是undefined则为空字符串）
    this.getFirendStr = function (str) {
        try {
            if (sysCommon.isNull(str)) {
                return "";
            } else {
                return str;
            }
        } catch (e) {
            console.log(e.message);
            return "";
        }
    }

    //判断是否是函数并 执行
    this.exeFunction = function (fun) {
        if ("function" == typeof (fun)) {
            return fun();
        }
        return true;
    }
    //服务端返回错误
    this.showErrorMsg = function (result) {
        if (!this.isNull(result.error)) {
            this.showAlert(result.error);
        } else {
            this.showAlert(result.info);
        }
    }

    //获取元素内容
    this.getInnerText = function (element) {
        return (typeof element.textContent == "string") ? element.textContent : element.innerText;
    }

    //设置元素的内容
    this.setInnerText = function (element, text) {
        if (typeof element.textContent == "string") {
            element.textContent = text;
        } else {
            element.innerText = text;
        }
    }

    //两种获取guid的方法-1
    this.guid = function () {
        return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function (c) {
            var r = Math.random() * 16 | 0, v = c == 'x' ? r : (r & 0x3 | 0x8);
            return v.toString(16);
        });
    }

    //两种获取guid的方法-2
    this.uuid = function () {
        var s = [];
        var hexDigits = "0123456789abcdef";
        for (var i = 0; i < 36; i++) {
            s[i] = hexDigits.substr(Math.floor(Math.random() * 0x10), 1);
        }
        s[14] = "4";  // bits 12-15 of the time_hi_and_version field to 0010
        s[19] = hexDigits.substr((s[19] & 0x3) | 0x8, 1);  // bits 6-7 of the clock_seq_hi_and_reserved to 01
        s[8] = s[13] = s[18] = s[23] = "-";

        var uuid = s.join("");
        return uuid;
    }

    //获取当前时间
    this.getNowDateTime = function () {
        var date = new Date();
        var month = date.getMonth() + 1
        if (month < 10) { month = "0" + month; }
        var day = date.getDate();
        if (day < 10) { day = "0" + day; }
        return date.getFullYear() + "-" + month + "-" + day + " " + (date.getHours() < 10 ? ("0" + date.getHours()) : date.getHours()) + ":" + (date.getMinutes() < 10 ? ("0" + date.getMinutes()) : date.getMinutes()) + ":" + (date.getSeconds() < 10 ? ("0" + date.getSeconds()) : date.getSeconds());
    }
    //获取当前日期
    this.getNowDate = function () {
        var date = new Date();
        var month = date.getMonth() + 1
        if (month < 10) { month = "0" + month; }
        var day = date.getDate();
        if (day < 10) { day = "0" + day; }
        return date.getFullYear() + "-" + month + "-" + day;
    }

    //获取字符串时间的时间戳
    //"2014-07-10 10:21:12"
    this.GetTimesTamp = function (stringTime) {
        // 获取某个时间格式的时间戳
        if (that.isNull(stringTime)) {
            that.showError("字符串时间为空");
            return;
        }
        //return Date.parse(new Date(stringTime));

        stringTime = stringTime.substring(0, 19);
        //date = date.replace(/-/g, "/");
        var timestamp = new Date(stringTime).getTime();
        return timestamp;

        //2014-07-10 10:21:12的时间戳为：1404958872 
        // console.log(stringTime + "的时间戳为：" + timestamp2);
    }

    //时间戳转为时间
    this.GetDateTime4Timestamp = function (timestamp, timeZone, isFull) {
        if (typeof (timeZone) == 'number') {
            timestamp = parseInt(timestamp) + parseInt(timeZone) * 60 * 60;
        }

        var time = new Date(timestamp);
        var ymdhis = "";
        ymdhis += time.getUTCFullYear() + "-";
        var month = (time.getUTCMonth() + 1);
        if (month < 10) {
            month = "0" + month;
        }
        ymdhis += month + "-";
        var day = time.getUTCDate();
        if (day < 10) {
            day = "0" + day;
        }
        ymdhis += day;
        if (isFull === true) {
            ymdhis += " " + time.getUTCHours() + ":";
            ymdhis += time.getUTCMinutes() + ":";
            ymdhis += time.getUTCSeconds();
        }
        return ymdhis;
    }
    //将后台date类型转为字符串
    this.GetDate2DateStr = function (date) {
        if (null == date || "" == date) {
            return "";
        }
        var mon = date.month + 1;
        if (mon < 10) {
            mon = "0" + mon;
        }
        var day = date.date;
        if (day < 10) {
            day = "0" + day;
        }
        return (date.year + 1900) + "-" + mon + "-" + day;
    }
    //将0，1 转为是否
    this.GetYesNo = function (intVal) {
        if (this.isNull(intVal)) {
            return "";
        }
        if (0 == intVal) {
            return "否";
        } else {
            return "是";
        }
    }

    //隐藏控件
    this.HideObj = function (obj) {
        try {
            if (this.isNotNull(obj)) {
                obj[0].style.display = "none";
            }
        } catch (e) {
            console.log(e.message);
        }
    }
    //显示控件
    this.ShowObj = function (obj) {
        try {
            if (this.isNotNull(obj)) {
                obj[0].style.display = "";
            }
        } catch (e) {
            console.log(e.message);
        }
    }
    //滚动到底部自动加载更多
    this.ScrollLoadMore = function (callback) {
        try {
            var that = this;
            $(window).scroll(function () {
                var scrollTop = $(this).scrollTop();
                var scrollHeight = $(document).height();
                var windowHeight = $(this).height();
                if (scrollTop + windowHeight == scrollHeight) {

                    //此处是滚动条到底部时候触发的事件，在这里写要加载的数据，或者是拉动滚动条的操作
                    that.exeFunction(callback);


                    //var page = Number($("#redgiftNextPage").attr('currentpage')) + 1;
                    //redgiftList(page);
                    //$("#redgiftNextPage").attr('currentpage', page + 1);

                }
            });

        } catch (e) {
            console.log(e.message);
        }

    }

    //返回顶部
    this.ScrollTop = function () {
        $(document).scrollTop(0);
    }

    //设置定时器
    this.SetInterval = function (fun, millisec) {
        var int = self.setInterval(function () {
            that.exeFunction(fun);
        }, millisec);
        return int;


    }
    //取消定时器
    this.CancelInterval = function (int) {
        var ints = window.clearInterval(int);
        return ints;
    }

    //日志
    this.ShowLog = function (msg) {
        if (sysConfig.Debug) {
            console.log(this.getNowDateTime() + ": " + msg);
        }
    }



    //--------------------------------------
    //图片上传插件（暂时不上传文件）
    this.UploadImage = function (autoUplaod, multiSelect, queueSizeLimit, divId, uploadBtnId, args, url, uploadName, onUploadSuccess, externalfunction, onUploadStart) {
        if (that.isNull(autoUplaod)) {
            autoUplaod = false;
        }
        if (that.isNull(multiSelect)) {
            multiSelect = false;
        }
        if (that.isNull(queueSizeLimit)) {
            queueSizeLimit = 1;
        }
        $("#" + divId).uploadify({
            'buttonText': '请选择图片',
            swf: 'lib/uploadify/uploadify.swf',
            'formData': args,
            'fileObjName': uploadName,
            uploader: url,
            'cancelImg': 'lib/uploadify/uploadify-cancel.png',//取消图片路径
            'fileTypeExts': '*.jpg;*.jpge;*.gif;*.png',
            'fileTypeDesc': '不超过2M的图片 (*.gif;*.jpg;*.png)',
            'fileSizeLimit': '2MB',
            'auto': autoUplaod,
            'multi': multiSelect,//文件选择时。同时选择多个文件
            'progressData': "speed",//percentage显示上传百分比，speed显示上传速度
            'height': 30,
            'queueSizeLimit': queueSizeLimit,//最多可以上传几个
            'removeTimeout': 0,
            'hideButton': 'true',
            'removeCompleted': false,//是否自动将已完成任务从队列中删除，如果设置为false则会一直保留此任务显示。
            'width': 120,
            'overrideEvents': ['onDialogClose', 'onSelectError', 'onUploadError'],
            'onSelectError': function (file, errorCode, errorMsg) {
                var msgText = "请重新选择:\n";
                switch (errorCode) {
                    case SWFUpload.QUEUE_ERROR.QUEUE_LIMIT_EXCEEDED:
                        //this.queueData.errorMsg = "每次最多上传 " + this.settings.queueSizeLimit + "个文件";  
                        msgText += "每次最多上传 " + this.settings.queueSizeLimit + "个文件";
                        break;
                    case SWFUpload.QUEUE_ERROR.FILE_EXCEEDS_SIZE_LIMIT:
                        msgText += "文件大小超过限制( " + this.settings.fileSizeLimit + " )";
                        break;
                    case SWFUpload.QUEUE_ERROR.ZERO_BYTE_FILE:
                        msgText += "文件大小为0";
                        break;
                    case SWFUpload.QUEUE_ERROR.INVALID_FILETYPE:
                        msgText += "文件格式不正确，仅限 " + this.settings.fileTypeExts;
                        break;
                    default:
                        msgText += "错误代码：" + errorCode + "\n" + errorMsg;
                }
                that.showAlert(msgText);
                return false;
            },
            'onSelect': function (file) {
                //alert('The file ' + file.name + ' was added to the queue.');
            },
            'onUploadStart': function (a, b, c, d) {
                if ("function" == typeof (onUploadStart)) {
                    onUploadStart(); 
                }
            
            },
            'onUploadComplete': function (file) {
                //alert('The file ' + file.name + ' finished processing.');

            },
            'onUploadSuccess': function (file, data, response) {
                if ("function" == typeof (onUploadSuccess)) {
                    onUploadSuccess(file, data, response);

                    $("#" + divId).uploadify('cancel', '*');
                }
                //alert('The file ' + file.name + ' was successfully uploaded with a response of ' + response + ':' + data);
            },
            'onUploadError': function (file, errorCode, errorMsg, errorString) {
                // 手工取消不弹出提示  
                if (errorCode == SWFUpload.UPLOAD_ERROR.FILE_CANCELLED
                        || errorCode == SWFUpload.UPLOAD_ERROR.UPLOAD_STOPPED) {
                    return;
                }
                var msgText = "上传失败\n";
                switch (errorCode) {
                    case SWFUpload.UPLOAD_ERROR.HTTP_ERROR:
                        msgText += "HTTP 错误\n" + errorMsg;
                        break;
                    case SWFUpload.UPLOAD_ERROR.MISSING_UPLOAD_URL:
                        msgText += "上传文件丢失，请重新上传";
                        break;
                    case SWFUpload.UPLOAD_ERROR.IO_ERROR:
                        msgText += "IO错误";
                        break;
                    case SWFUpload.UPLOAD_ERROR.SECURITY_ERROR:
                        msgText += "安全性错误\n" + errorMsg;
                        break;
                    case SWFUpload.UPLOAD_ERROR.UPLOAD_LIMIT_EXCEEDED:
                        msgText += "每次最多上传 " + this.settings.uploadLimit + "个";
                        break;
                    case SWFUpload.UPLOAD_ERROR.UPLOAD_FAILED:
                        msgText += errorMsg;
                        break;
                    case SWFUpload.UPLOAD_ERROR.SPECIFIED_FILE_ID_NOT_FOUND:
                        msgText += "找不到指定文件，请重新操作";
                        break;
                    case SWFUpload.UPLOAD_ERROR.FILE_VALIDATION_FAILED:
                        msgText += "参数错误";
                        break;
                    default:
                        msgText += "文件:" + file.name + "\n错误码:" + errorCode + "\n"
                                + errorMsg + "\n" + errorString;
                }
                that.showAlert(msgText);
            }

        });

        //上传
        $("#" + uploadBtnId).unbind("click");
        $("#" + uploadBtnId).click(function () {
            $("#" + divId).uploadify('upload', '*');
        });
        that.exeFunction(externalfunction);
    }
    //======================================

};
var sysCommon = new _sysCommon();


//左侧导航栏组件
function sysLeftNavBar(json) {
    this.id = json.id;
    this.count = json.length;
    this.items = [];
    this.showRIcon = json.showRIcon == undefined ? false : json.showRIcon;
    var that = this;
    function init() {
        for (var i = 0; i < json.data.length; i++) {
            var id = json.data[i].id == "" ? sysCommon.guid() : json.data[i].id;
            var fn = json.data[i].fn == "" ? "" : ("onclick='" + json.data[i].fn + "();'");
            $("#" + that.id).append('<a href="' + json.data[i].href + '" id="' + id + '" class="list-group-item"  ' + fn + ' name="' + json.data[i].name + '">' + json.data[i].span + '</a>');
            that.items.push({ "id": $("#" + id)[0].id, name: json.data[i].name });
        }
        $("#" + that.id + " a").bind("click", function () {
            $(this).addClass("active").siblings().removeClass("active");
            if (undefined != json.rightTtID && "" != json.rightTtID) {
                if (true == that.showRIcon) {
                    $("#" + json.rightTtID).html($("#" + this.id)[0].innerHTML);
                } else {
                    sysCommon.setInnerText($("#" + json.rightTtID)[0], sysCommon.getInnerText($("#" + this.id)[0]));
                }
            }
        });

    }
    init();
}



//右侧panel
function sysRightPanel(title, body, confimFunc, cancelFunc, externalfunction) {
    var that = this;
    if (!sysCommon.isNull($("#yhaiRightPanel"))) {
        $("#yhaiRightPanel").remove();
    }
    if (sysCommon.isNull(title)) { title = ""; }
    var html = '<div id="yhaiRightPanel" style="position: absolute;z-index: 99999;right: 41px;width: 70%;top:60px">'
            + '	<div class="panel panel-info" id="tablePanelMain">'
            + '		<div class="panel-heading">'
            + '			<h3 class="panel-title" id="yhaiRightPanelTitle">' + title + '</h3>'
            + '		</div>'
            + '		<div class="panel-body" id="yhaiRightPanelContent">'
            + '<form class="form-horizontal" role="form">'
            + body
            + '<div class="form-group" class="col-sm-offset-2 col-sm-10">'
            + '   <hr/>'
            + '<div class="col-sm-offset-3 col-sm-9">'
            + '   <button type="button" class="btn btn-primary" id="yhaiRightPanelConfim">确定</button>'
            + '   <button type="button" class="btn btn-default" id="yhaiRightPanelCanl">取消</button>'
            + '</div>'
            + '</div>'
            + '</form>'
            + '		</div>'
            + '	</div>'
            + '</div>';
    //$(document.body).append(html);
    $("#gridboxDIV").append(html);
    //确定按钮事件
    $("#yhaiRightPanelConfim").unbind("click");
    $("#yhaiRightPanelConfim").click(function () {
        if (sysCommon.exeFunction(confimFunc)) {
            $("#yhaiRightPanel")[0].style.display = "none";
            $("#yhaiRightPanel").remove();
        }
    });
    //取消按钮事件
    $("#yhaiRightPanelCanl").unbind("click");
    $("#yhaiRightPanelCanl").click(function () {
        if (sysCommon.exeFunction(cancelFunc)) {
            $("#yhaiRightPanel")[0].style.display = "none";
            $("#yhaiRightPanel").remove();
        }
    });
    this.close = function () {
        $("#yhaiRightPanel")[0].style.display = "none";
        $("#yhaiRightPanel").remove();
    }


    if ("function" == typeof (externalfunction)) {
        try {
            externalfunction();
        } catch (e) {
            console.log(e.message);
        }
    }
}


//构造表格
function sysXGrid(g) {
    //var g = {
    //    divID: "gridbox",
    //    header: "CH,Book Title,作者,价格,flag,time",//设置标题(必须)
    //    colWidth: "65,260,300,200,100,120",//设置初始列宽
    //    colAlign: "left,left,left,right,left,left",//设置对齐方式
    //    colTypes: "ch,ed,ed,ed,ed,ed",//设置列类型(必须)
    //    colSorting: "int,str,str,int,int,date",//设置列排序类型
    //    data: data,//加载数据
    //    attachEvent: [
    //        ["onRowSelect", function (id) {
    //            document.getElementById("a_1").innerHTML = "Selected row id: " + id;
    //        }],
    //        ["", function () {
    //        }]
    //    ]
    //};
    this.divID = g.divID == undefined ? sysCommon.showError(yhaiErrorType.GridDivIDNotNull) : g.divID;
    this.header = g.header == undefined ? sysCommon.showError(yhaiErrorType.GridHeaderNotNull) : g.header;
    this.colWidth = g.colWidth == undefined ? "" : g.colWidth;
    this.colAlign = g.colAlign == undefined ? "" : g.colAlign;
    this.colTypes = g.colTypes == undefined ? sysCommon.showError(yhaiErrorType.GridColTypeNotNull) : g.colTypes;
    this.colSorting = g.colSorting == undefined ? "" : g.colSorting;
    this.data = (g.data == undefined || g.data == null || g.data == "") ? [] : { rows: g.data };
    this.attachEvent = g.attachEvent == undefined ? null : g.attachEvent;

    //初始化表格
    var myGrid = new dhtmlXGridObject(this.divID);
    myGrid.setImagePath(sysConfig.gridConfig.imgPath);//设置图片路径
    myGrid.setSkin(sysConfig.gridConfig.skin);//设置自定义皮肤
    myGrid.setHeader(this.header);//设置标题
    myGrid.setInitWidths(this.colWidth);//设置初始列宽
    myGrid.setColAlign(this.colAlign);//设置对齐方式
    myGrid.setColTypes(this.colTypes);//设置列类型
    myGrid.setColSorting(this.colSorting);//设置列排序类型
    myGrid.selMultiRows = true;
    //myGrid.setColumnColor("#CCE2FE");    
    //myGrid.attachEvent("onRowSelect", doOnRowSelect);//设置选中行事件
    if (null != this.attachEvent) {
        $.each(this.attachEvent, function (key, value) {
            myGrid.attachEvent(value[0], value[1]);//设置选中行事件
        });
    }
    myGrid.enableRowsHover(true, 'grid_hover');//设置行hover样式
    myGrid.enableAlterCss("even", "uneven");//间隔样式
    myGrid.init();//初始化表格
    // myGrid.load(this.data, this.dataType);//加载数据
    myGrid.parse(this.data, "json");


    return myGrid;
}


//弹出模态框
var sysModal = function (title, body, confimfn, cancelfn, islg, externalfunction) {
    if ($("#myModal") && $("#myModal").length > 0) {
        $("#myModal").remove();
    }
    //是否大模态框
    var lg = "";
    if (true == islg) { lg = "modal-lg"; }
    var html = '<div class="modal" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true"> <div class="modal-dialog ' + lg + '"> <div class="modal-content"> <div class="modal-header"> <button type="button" class="close" data-dismiss="modal" aria-hidden="true"> &times; </button> <h4 class="modal-title" id="myModalLabel">' + title + '</h4> </div> <div class="modal-body">' + body + '</div> <div class="modal-footer" id="modal_footer"><button type="button" class="btn btn-primary" id="btnConfim">确认</button><button type="button" class="btn btn-default" id="btnCanl" >取消</button></div></div></div></div>';
    $(document.body).append(html);
    $('#myModal').modal({
        keyboard: true
    });

    //确定按钮事件
    $("#btnConfim").unbind("click");
    $("#btnConfim").click(function () {
        if ("function" == typeof (confimfn)) {
            if (true == confimfn()) {
                $('#myModal').modal('hide');
            }
        } else {
            $('#myModal').modal('hide');
        }
    });
    //取消按钮事件
    $("#btnCanl").unbind("click");
    $("#btnCanl").click(function () {
        if ("function" == typeof (cancelfn)) {
            if (true == cancelfn()) {
                $('#myModal').modal('hide');
            }
        } else {
            $('#myModal').modal('hide');
        }
    });

    //展示模态框
    $('#myModal').modal({
        keyboard: true
    });

    if ("function" == typeof (externalfunction)) {
        try {
            externalfunction();
        } catch (e) {
            console.log(e.message);
        }
    }

}



function sysTree(divID, data, clickfn) {

    var IDMark_Switch = "_switch";
    var IDMark_Icon = "_ico";
    var IDMark_Span = "_span";
    var IDMark_Input = "_input";
    var IDMark_Check = "_check";
    var IDMark_Ul = "_ul";
    var IDMark_A = "_a";
    var setting = {
        edit: {
            enable: true, showRemoveBtn: false, showRenameBtn: false
        },
        data: {
            key: {
                //itle: "m",
                // name: "text",
                //url: "u"
            },
            simpleData: {
                enable: true
            }
        },
        view: {
            showLine: false,
            addHoverDom: addHoverDom,
            removeHoverDom: removeHoverDom
        },
        callback: {
            onClick: onClick
        }
    };


    //点击树节点事件
    function onClick(event, treeId, treeNode, clickFlag) {
        if ($(".paddTee").length > 0 && $("#diyBtn3_" + treeNode.id).length <= 0) {
            $(".paddTee").unbind().remove();
        }
        $("#gridTitleName").html(treeNode.name);
        if ("function" == typeof (clickfn)) {
            clickfn();
        }
    }

    //hover节点下拉功能按钮
    function addHoverDom(treeId, treeNode) {
        if (treeNode.parentNode && treeNode.parentNode.id != 1) return;
        var aObj = $("#" + treeNode.tId + IDMark_A);
        //1. 设置按钮
        if ($("#diyBtn1_" + treeNode.id).length > 0) return;
        var editStr = "<a id='diyBtn1_" + treeNode.id + "' style='margin:0 0 0 0px; background-color: #fff;padding-left:5px;'>设置</a>";
        aObj.append(editStr);
        var btn = $("#diyBtn1_" + treeNode.id);
        if (btn) btn.bind("click", function () {
            var editStr = '<div class="paddTee" id="diyBtn3_' + treeNode.id + '"> <span data-type="next">新建下级部门</span> <span  data-type="level">新建平级部门</span> <span class="line"></span> <span data-type="edit">编辑部门</span> <span data-type="disable">停用部门</span> <span data-type="delete">删除部门</span> </div>';
            //当为树根节点时只有新建下级
            if (null == treeNode.pId) {
                editStr = '<div class="paddTee" style="margin-left:75px;" id="diyBtn3_' + treeNode.id + '"> <span style="font-size:10pt;font-weight:normal;" data-type="next">新建下级部门</span> </div>';
            }
            if (treeNode.parentNode && treeNode.parentNode.id != 1) return;
            var aObj = $("#" + treeNode.tId + IDMark_A);
            if ($(".paddTee").length > 0 && $("#diyBtn3_" + treeNode.id).length <= 0) {
                $(".paddTee").unbind().remove();
            }
            if ($("#diyBtn3_" + treeNode.id).length > 0) return;

            aObj.append(editStr);
            thisID = treeNode.id;
            btnFunc(treeNode);
        });
    }
    //hover节点删除下拉功能按钮
    function removeHoverDom(treeId, treeNode) {
        $("#diyBtn1_" + treeNode.id).unbind().remove();
        $("#diyBtn2_" + treeNode.id).unbind().remove();
    }

    //点击下拉功能节点事件
    function btnFunc(treeNode) {
        $(".paddTee span").unbind();
        $(".paddTee span").bind("click", function () {
            $("#diyBtn3_" + treeNode.id).unbind().remove();

            switch ($(this).attr("data-type")) {
                case "next": {//下级
                    Department.AddNewDept(treeNode, true);
                }
                    break;
                case "level": {//平级
                    Department.AddNewDept(treeNode, false);
                }
                    break;
                case "edit": {//编辑部门
                    Department.EditDept(treeNode);
                }
                    break;
                case "disable": {//停用部门
                    Department.DisableDepart(treeNode);
                }
                    break;
                case "delete": {//删除部门
                    Department.DeleteDepart(treeNode);
                }
                    break;
            }
        });
    }

    //创建树
    if ("" == divID || undefined == divID || null == divID) {
        layer.msg("树容器未定义");
    }

    $("#" + divID).html('<ul id="' + divID + 'UL" class="ztree"></ul>');
    return $.fn.zTree.init($("#" + divID + "UL"), setting, data);
}


//哈希表
function HashTable() {
    //存数据的实体
    this._Hash = new Object();

    //新增键值
    this.Add = function (key, value)  {
        if (typeof (key) != "undefined") {
            if (this.Contains(key) == false) {
                this._Hash[key] = value;
                return true;
            }
            else {
                return false;
            }
        }
        else {
            return false;
        }
    }

    //删除键值
    this.Remove = function (key) { delete this._Hash[key]; }

    //数量
    this.Count = function () { var i = 0; for (var k in this._Hash) { i++; } return i; }

    //获取值
    this.Items = function (key) {
        var value = this._Hash[key];
        return typeof (value) == "undefined" ? null : value
    }

    //获取值
    this.GetValue = function (key) {
        return this.Items(key);
    }

    //获取值
    this.Get = function (key) {
        return this.Items(key);
    }

    //赋值
    this.SetValue = function (key, value) {
        return this._Hash[key] = value;
    }

    //是否包含键
    this.Contains = function (key) { return typeof (this._Hash[key]) != "undefined"; }

    //清空哈希表
    this.Clear = function () { for (var k in this._Hash) { delete this._Hash[k]; } }

    //获取所有键
    this.AllKeys = function () { return this._Hash; }
}



//cookie
var sysCookie = {
    //获取cookie
    "GetCookie": function (c_name) {
        if (document.cookie.length > 0) {
            c_start = document.cookie.indexOf(c_name + "=");
            if (c_start != -1) {
                c_start = c_start + c_name.length + 1;
                c_end = document.cookie.indexOf(";", c_start);
                if (c_end == -1) c_end = document.cookie.length;
                return unescape(document.cookie.substring(c_start, c_end));
            }
        }
        return "";
    },
    //设置cookie
    "SetCookie": function (c_name, value, expiredays) {
        var exdate = new Date();
        if (undefined == expiredays || null == expiredays || "" == expiredays) {
            expiredays = 365;
        }
        exdate.setDate(exdate.getDate() + expiredays);
        document.cookie = c_name + "=" + escape(value) + ((expiredays == null) ? "" : "; expires=" + exdate.toGMTString());
    },
    //检查cookie
    "CheckCookie": function (name) {
        username = this.GetCookie(name)
        if (username != null && username != "") {
            return true;
        }
        else {
            return false;
        }
    },
    //删除cookie
    "DeleteCookie": function (name) {
        var date = new Date();
        date.setTime(date.getTime() - 10000);
        document.cookie = name + "=v; expire=" + date.toGMTString();
    },
    //清空cookie
    "ClearCookie": function () {
        var keys = document.cookie.match(/[^ =;]+(?=\=)/g);
        if (keys) {
            for (var i = keys.length; i--;)
                document.cookie = keys[i] + '=0;expires=' + new Date(0).toUTCString()
        }
    }
}




