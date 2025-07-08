// 新闻发布管理系统主JavaScript文件

$(document).ready(function() {
    // 初始化所有功能
    initializeCarousel();
    initializeAnimations();
    initializeFormValidation();
    initializeTooltips();
    initializeSearch();
    initializeNewsCards();
    
    // 自动隐藏警告消息
    setTimeout(function() {
        $('.alert').fadeOut('slow');
    }, 5000);
});

// 初始化轮播图
function initializeCarousel() {
    $('.carousel').carousel({
        interval: 5000,
        pause: 'hover'
    });
    
    // 添加轮播图指示器点击事件
    $('.carousel-indicators li').click(function() {
        var index = $(this).data('slide-to');
        $('.carousel').carousel(index);
    });
}

// 初始化动画效果
function initializeAnimations() {
    // 页面滚动时添加动画
    $(window).scroll(function() {
        $('.fade-in-up').each(function() {
            var elementTop = $(this).offset().top;
            var elementBottom = elementTop + $(this).outerHeight();
            var viewportTop = $(window).scrollTop();
            var viewportBottom = viewportTop + $(window).height();
            
            if (elementBottom > viewportTop && elementTop < viewportBottom) {
                $(this).addClass('animated');
            }
        });
    });
    
    // 导航栏滚动效果
    $(window).scroll(function() {
        if ($(window).scrollTop() > 50) {
            $('.navbar').addClass('navbar-scrolled');
        } else {
            $('.navbar').removeClass('navbar-scrolled');
        }
    });
}

// 初始化表单验证
function initializeFormValidation() {
    // 注册表单验证
    $('#registerForm').on('submit', function(e) {
        var password = $('#password').val();
        var confirmPassword = $('#confirmPassword').val();
        
        if (password !== confirmPassword) {
            e.preventDefault();
            showAlert('密码和确认密码不匹配', 'danger');
            return false;
        }
        
        if (password.length < 6) {
            e.preventDefault();
            showAlert('密码长度不能少于6个字符', 'danger');
            return false;
        }
    });
    
    // 登录表单验证
    $('#loginForm').on('submit', function(e) {
        var username = $('#username').val();
        var password = $('#password').val();
        
        if (!username || !password) {
            e.preventDefault();
            showAlert('请填写用户名和密码', 'danger');
            return false;
        }
    });
    
    // 新闻发布表单验证
    $('#newsForm').on('submit', function(e) {
        var title = $('#title').val();
        var content = $('#content').val();
        
        if (!title || title.length < 5) {
            e.preventDefault();
            showAlert('新闻标题不能少于5个字符', 'danger');
            return false;
        }
        
        if (!content || content.length < 50) {
            e.preventDefault();
            showAlert('新闻内容不能少于50个字符', 'danger');
            return false;
        }
    });
}

// 初始化工具提示
function initializeTooltips() {
    $('[data-toggle="tooltip"]').tooltip();
}

// 初始化搜索功能
function initializeSearch() {
    // 搜索框自动完成
    $('#searchInput').on('input', function() {
        var query = $(this).val();
        if (query.length > 2) {
            // 这里可以添加AJAX搜索建议功能
            console.log('搜索: ' + query);
        }
    });
    
    // 搜索表单提交
    $('#searchForm').on('submit', function(e) {
        var query = $('#searchInput').val();
        if (!query || query.trim().length < 2) {
            e.preventDefault();
            showAlert('请输入至少2个字符进行搜索', 'warning');
            return false;
        }
    });
}

// 初始化新闻卡片功能
function initializeNewsCards() {
    // 新闻卡片悬停效果
    $('.news-card').hover(
        function() {
            $(this).find('.news-card-image').addClass('zoom-in');
        },
        function() {
            $(this).find('.news-card-image').removeClass('zoom-in');
        }
    );
    
    // 新闻分享功能
    $('.share-btn').click(function(e) {
        e.preventDefault();
        var url = $(this).data('url');
        var title = $(this).data('title');
        shareNews(url, title);
    });
    
    // 新闻收藏功能
    $('.favorite-btn').click(function(e) {
        e.preventDefault();
        var newsId = $(this).data('news-id');
        toggleFavorite(newsId, $(this));
    });
}

// 显示警告消息
function showAlert(message, type) {
    var alertHtml = '<div class="alert alert-' + type + ' alert-dismissible fade show" role="alert">' +
                   message +
                   '<button type="button" class="close" data-dismiss="alert" aria-label="Close">' +
                   '<span aria-hidden="true">&times;</span>' +
                   '</button>' +
                   '</div>';
    
    $('#alertContainer').html(alertHtml);
    
    // 自动隐藏
    setTimeout(function() {
        $('.alert').fadeOut('slow');
    }, 5000);
}

// 新闻分享功能
function shareNews(url, title) {
    if (navigator.share) {
        navigator.share({
            title: title,
            url: url
        }).then(() => {
            console.log('分享成功');
        }).catch((error) => {
            console.log('分享失败:', error);
            fallbackShare(url, title);
        });
    } else {
        fallbackShare(url, title);
    }
}

// 备用分享方法
function fallbackShare(url, title) {
    var shareUrl = 'https://twitter.com/intent/tweet?text=' + encodeURIComponent(title) + '&url=' + encodeURIComponent(url);
    window.open(shareUrl, '_blank', 'width=600,height=400');
}

// 切换收藏状态
function toggleFavorite(newsId, button) {
    // 这里应该发送AJAX请求到后端
    $.ajax({
        url: '/api/news/' + newsId + '/favorite',
        method: 'POST',
        success: function(response) {
            if (response.favorited) {
                button.addClass('favorited');
                button.find('i').removeClass('far').addClass('fas');
                showAlert('已添加到收藏', 'success');
            } else {
                button.removeClass('favorited');
                button.find('i').removeClass('fas').addClass('far');
                showAlert('已取消收藏', 'info');
            }
        },
        error: function() {
            showAlert('操作失败，请重试', 'danger');
        }
    });
}

// 加载更多新闻
function loadMoreNews(page) {
    $.ajax({
        url: '/news?page=' + page,
        method: 'GET',
        beforeSend: function() {
            $('#loadMoreBtn').html('<span class="loading"></span> 加载中...');
        },
        success: function(response) {
            $('#newsList').append(response);
            $('#loadMoreBtn').html('加载更多');
        },
        error: function() {
            showAlert('加载失败，请重试', 'danger');
            $('#loadMoreBtn').html('加载更多');
        }
    });
}

// 确认删除对话框
function confirmDelete(message, callback) {
    if (confirm(message || '确定要删除吗？')) {
        callback();
    }
}

// 格式化日期
function formatDate(dateString) {
    var date = new Date(dateString);
    var now = new Date();
    var diff = now - date;
    
    var minutes = Math.floor(diff / 60000);
    var hours = Math.floor(diff / 3600000);
    var days = Math.floor(diff / 86400000);
    
    if (minutes < 1) {
        return '刚刚';
    } else if (minutes < 60) {
        return minutes + '分钟前';
    } else if (hours < 24) {
        return hours + '小时前';
    } else if (days < 7) {
        return days + '天前';
    } else {
        return date.toLocaleDateString('zh-CN');
    }
}

// 图片懒加载
function lazyLoadImages() {
    var images = document.querySelectorAll('img[data-src]');
    var imageObserver = new IntersectionObserver(function(entries, observer) {
        entries.forEach(function(entry) {
            if (entry.isIntersecting) {
                var img = entry.target;
                img.src = img.dataset.src;
                img.classList.remove('lazy');
                imageObserver.unobserve(img);
            }
        });
    });
    
    images.forEach(function(img) {
        imageObserver.observe(img);
    });
}

// 平滑滚动
function smoothScroll(target) {
    $('html, body').animate({
        scrollTop: $(target).offset().top - 70
    }, 800);
}

// 返回顶部功能
$(window).scroll(function() {
    if ($(this).scrollTop() > 300) {
        $('#backToTop').fadeIn();
    } else {
        $('#backToTop').fadeOut();
    }
});

$('#backToTop').click(function() {
    $('html, body').animate({scrollTop: 0}, 800);
    return false;
});

// 响应式导航菜单
$('.navbar-toggler').click(function() {
    $('.navbar-collapse').toggleClass('show');
});

// 主题切换功能（可选）
function toggleTheme() {
    $('body').toggleClass('dark-theme');
    var isDark = $('body').hasClass('dark-theme');
    localStorage.setItem('darkTheme', isDark);
}

// 加载保存的主题设置
$(document).ready(function() {
    var isDark = localStorage.getItem('darkTheme') === 'true';
    if (isDark) {
        $('body').addClass('dark-theme');
    }
});

// 实时时间显示
function updateTime() {
    var now = new Date();
    var timeString = now.toLocaleString('zh-CN');
    $('#currentTime').text(timeString);
}

// 每秒更新时间
setInterval(updateTime, 1000);

// 页面加载完成后的初始化
$(window).on('load', function() {
    // 隐藏加载动画
    $('#pageLoader').fadeOut();
    
    // 初始化懒加载
    lazyLoadImages();
    
    // 初始化时间显示
    updateTime();
});

