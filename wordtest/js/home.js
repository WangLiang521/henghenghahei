/// <reference path="commom.js" />



$(document).ready(function () {




    //分享
    $("#share").unbind("click");
    $("#share").click(function(){
        try{
            JSInterface.share();
//            window.jsInterface.share();//调用Android分享
        }catch(e){
//            sysCommon.showAlert(e.toString);
        }
    });


    var x = 0;
    var i = 0;
    function youC() {

        var data = lll.data;
        //使用eval解析 获取json里的数据
        if (i < data.length) {
            var obj = eval(lll);
            explains = obj.data[i].explain;
            //egENs = obj.data[i].egEN;
            words = obj.data[i].word;
            conf1 = obj.data[i].confWord1;
            conf2 = obj.data[i].confWord2;
            conf3 = obj.data[i].confWord3;

            //随机排序
            var arr = [words, conf1, conf2, conf3];
            function randomSort(a, b) {
                return Math.random() - 0.5;//返回-0.5—— +0.5的数字
            }
            var result = [];
            result = arr.sort(randomSort);


            //赋值
            $(".btn-words").delay(5000).removeClass("wrong");
            $(".btn-words").delay(5000).removeClass("right");
            $("#explain").html(explains);
            //$("#egEN").html(egENs);
            $("#con1").html(result[0]);
            $("#con2").html(result[1]);
            $("#con3").html(result[2]);
            $("#con4").html(result[3]);


            $(".btn-words").unbind("click");
            $(".btn-words").click(function () {

                if (words == $(this).text()) {

                    $(this).addClass("right");
                    i++;
                    ++x;
                    var times;
                    times = setTimeout(function () {
                        youC();
                    }, 300);
                    //clearInterval(times);
                    run();

                } else {

                    $(this).addClass("wrong");
                    $(".btn-words").each(function () {
                        if (words == $(this).text()) {
                            $(this).addClass("right");
                        }

                    })
                    i++;
                    var times;
                    times = setTimeout(function () {
                        youC();
                    }, 300);
                    //clearInterval(times);
                    run();
                }
                var d = data.length;
                totaled = Math.round(x / d * 100);
                $("#fenshu").html(totaled);
                if (100 == totaled) {
                    $("#cents").html("成绩真棒");
                    $("#sum").html("我来学习的目标只有一个,让自己100%完美。")
                } else {
                    $("#cents").html("小学水平");
                    $("#sum").html("你的成绩有很大的提升空间。");
                }
            })

        }
    }
    youC();

    function run() {
        var bar = document.getElementById("bar");
        var total = document.getElementById("total");
        bar.style.width = parseInt(bar.style.width) + 15 + "%";
        total.innerHTML = bar.style.width;
        var b = '105%';
        if (bar.style.width == b) {
            $(".panel").find(".titlesd").css("display", "block");
            $(".panel").find(".title").css("display", "none");

        }
    }



})































