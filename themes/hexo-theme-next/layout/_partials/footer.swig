

<div class="copyright">{#
#}{% set current = date(Date.now(), "YYYY") %}{#
#}&copy; {% if theme.footer.since and theme.footer.since != current %}{{ theme.footer.since }} &mdash; {% endif %}{#
#}<span itemprop="copyrightYear">{{ current }}</span>
  <span class="with-love" id="heart">
    <i class="fa fa-{{ theme.footer.icon }}"></i>
  </span>
  <span class="author" itemprop="copyrightHolder">{{ theme.footer.copyright || config.author }}</span>

  {% if theme.post_wordcount.totalcount %}
    <span class="post-meta-divider">|</span>
    <span class="post-meta-item-icon">
      <i class="fa fa-area-chart"></i>
    </span>
    {% if theme.post_wordcount.item_text %}
      <span class="post-meta-item-text">{{ __('post.totalcount') }}&#58;</span>
    {% endif %}
    <span title="{{ __('post.totalcount') }}">{#
    #}{{ totalcount(site, '0,0.0a') }}{#
  #}</span>
  {% endif %}
</div>


{% if theme.footer.counter %}
  <script async src="https://busuanzi.ibruce.info/busuanzi/2.3/busuanzi.pure.mini.js"></script>
  <span id="busuanzi_container_site_uv">访客数：<span id="busuanzi_value_site_uv"></span>人次</span>
  <span class="post-meta-divider">|</span>
  <span id="busuanzi_container_site_pv">总访问量：<span id="busuanzi_value_site_pv"></span>次</span>
  <span class="post-meta-divider">|</span>
{% endif %}


<div class="theme-info">
  <div class="powered-by"></div>
  <span class="post-count">全站共：{{ totalcount(site) }}字</span>
</div>

{% if theme.copyright %}
<div class="theme-info">
  xxxxxxxxxxxxxxxxxxxxxx
</div>
{% endif %}
<div style="width:300px;margin:0 auto; padding:10px 0;">
    <a target="_blank"  style="display:inline-block;text-decoration:none;height:20px;line-height:20px;"><img src="" style="float:left;"/><p style="float:left;height:20px;line-height:20px;margin: 0px 0px 0px 5px; color:#939393;">粤ICP备18144842号</p></a>
</div>
