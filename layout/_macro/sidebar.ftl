<#macro sidebar_template is_post>
  <div class="sidebar-toggle">
      <div class="sidebar-toggle-line-wrap">
          <span class="sidebar-toggle-line sidebar-toggle-line-first"></span>
          <span class="sidebar-toggle-line sidebar-toggle-line-middle"></span>
          <span class="sidebar-toggle-line sidebar-toggle-line-last"></span>
      </div>
  </div>

  <aside id="sidebar" class="sidebar">
      <#if options.next_style_sidebar_onmobile?default('false')=='true'>
      <div id="sidebar-dimmer"></div>
      </#if>
      <div class="sidebar-inner">

          {% set display_toc = is_post and theme.toc.enable or is_page and theme.toc.enable %}

          {% if display_toc and toc(page.content).length > 1 %}
          <ul class="sidebar-nav motion-element">
              <li class="sidebar-nav-toc sidebar-nav-active" data-target="post-toc-wrap">
                  文章目录
              </li>
              <li class="sidebar-nav-overview" data-target="site-overview-wrap">
                  站点概览
              </li>
          </ul>
          {% endif %}

          <section
                  class="site-overview-wrap sidebar-panel{% if not display_toc or toc(page.content).length <= 1 %} sidebar-panel-active{% endif %}">
              <div class="site-overview">
                  <div class="site-author motion-element" itemprop="author" itemscope
                       itemtype="http://schema.org/Person">
                      <#if user.userAvatar??>
                      <img class="site-author-image" itemprop="image"
                           src="${user.userAvatar?default('/next/source/images/avatar.gif')}"
                           alt="${user.userDisplayName?if_exists}"/>
                      </#if>
                      <p class="site-author-name" itemprop="name">${user.userDisplayName?if_exists}</p>
                      <p class="site-description motion-element" itemprop="description">
                          <#if options.next_other_seo?default('false')=='true'>
                          {{ theme.signature }}
                          <#else>
                          {{ theme.description }}
                          </#if>
                      </p>
                  </div>

                  <nav class="site-state motion-element">

                      {% if config.archive_dir != '/' and site.posts.length > 0 %}
                      <div class="site-state-item site-state-posts">
                          {% if theme.menu.archives %}
                          <a href="{{ url_for(theme.menu.archives).split('||')[0] | trim }}">
                              {% else %}
                              <a href="{{ url_for(config.archive_dir) }}">
                                  {% endif %}
                                  <span class="site-state-item-count">{{ site.posts.length }}</span>
                                  <span class="site-state-item-name">日志</span>
                              </a>
                      </div>
                      {% endif %}

                      {% if site.categories.length > 0 %}
                      {% set categoriesPageQuery = site.pages.find({type: 'categories'}, {lean: true}) %}
                      {% set hasCategoriesPage = categoriesPageQuery.length > 0 %}
                      <div class="site-state-item site-state-categories">
                          {% if hasCategoriesPage %}<a href="{{ url_for(categoriesPageQuery[0].path) }}">{% endif %}
                          <span class="site-state-item-count">{{ site.categories.length }}</span>
                          <span class="site-state-item-name">分类</span>
                          {% if hasCategoriesPage %}</a>{% endif %}
                      </div>
                      {% endif %}

                      {% if site.tags.length > 0 %}
                      {% set tagsPageQuery = site.pages.find({type: 'tags'}, {lean: true}) %}
                      {% set hasTagsPage = tagsPageQuery.length > 0 %}
                      <div class="site-state-item site-state-tags">
                          {% if hasTagsPage %}<a href="{{ url_for(tagsPageQuery[0].path) }}">{% endif %}
                          <span class="site-state-item-count">{{ site.tags.length }}</span>
                          <span class="site-state-item-name">标签</span>
                          {% if hasTagsPage %}</a>{% endif %}
                      </div>
                      {% endif %}

                  </nav>

                  <#if options.next_other_rss?default('true') == 'true'>
                  <div class="feed-link motion-element">
                      <a href="/feed.xml" rel="alternate">
                          <i class="fa fa-rss"></i>
                          RSS
                      </a>
                  </div>
                  </#if>

                  {% if theme.social %}
                  <div class="links-of-author motion-element">
                      {% for name, link in theme.social %}
                      <span class="links-of-author-item">
                    <a href="{{ link.split('||')[0] | trim }}" target="_blank" title="{{ name }}">
                      {% if theme.social_icons.enable %}
                        <i class="fa fa-fw fa-{{ link.split('||')[1] | trim | default('globe') }}"></i>
                        {% endif %}
                        {% if not theme.social_icons.icons_only %}
                        {{ name }}
                        {% endif %}
                    </a>
                  </span>
                      {% endfor %}
                  </div>
                  {% endif %}

                  {% set cc = {'by': 1, 'by-nc': 1, 'by-nc-nd': 1, 'by-nc-sa': 1, 'by-nd': 1, 'by-sa': 1, 'zero': 1} %}
                  {% if theme.creative_commons in cc %}
                  <div class="cc-license motion-element" itemprop="license">
                      <a href="https://creativecommons.org/{% if theme.creative_commons === 'zero' %}publicdomain/zero/1.0{% else %}licenses/{{ theme.creative_commons }}/4.0{% endif %}/"
                         class="cc-opacity" target="_blank">
                          <img src="{{ url_for(theme.images) }}/cc-{{ theme.creative_commons }}.svg"
                               alt="Creative Commons"/>
                      </a>
                  </div>
                  {% endif %}
                  {% if theme.links %}
                  <div class="links-of-blogroll motion-element {{ " links-of-blogroll-
                  " + theme.links_layout | default('inline') }}">
                  <div class="links-of-blogroll-title">
                      <i class="fa  fa-fw fa-{{ theme.links_icon | default('globe') | lower }}"></i>
                      {{ theme.links_title }}
                  </div>
                  <ul class="links-of-blogroll-list">
                      {% for name, link in theme.links %}
                      <li class="links-of-blogroll-item">
                          <a href="{{ link }}" title="{{ name }}" target="_blank">{{ name }}</a>
                      </li>
                      {% endfor %}
                  </ul>
              </div>
              {% endif %}

          <#include "../_custom/sidebar.ftl">
      </div>
      </section>

      {% if display_toc and toc(page.content).length > 1 %}
      <!--noindex-->
      <section class="post-toc-wrap motion-element sidebar-panel sidebar-panel-active">
          <div class="post-toc">

              {% if page.toc_number === undefined %}
              {% set toc = toc(page.content, { "class": "nav", list_number: theme.toc.number }) %}
              {% else %}
              {% set toc = toc(page.content, { "class": "nav", list_number: page.toc_number }) %}
              {% endif %}

              {% if toc.length <= 1 %}
              <p class="post-toc-empty">此文章未包含目录</p>
              {% else %}
              <div class="post-toc-content">{{ toc }}</div>
              {% endif %}

          </div>
      </section>
      <!--/noindex-->
      {% endif %}

      <#if options.next_style_sidebar_b2t?default('false')=='true'>
      <div class="back-to-top">
          <i class="fa fa-arrow-up"></i>
          <#if options.next_style_sidebar_scrollpercent?default('false')=='true'>
          <span id="scrollpercent"><span>0</span>%</span>
          </#if>
      </div>
      </#if>

      </div>
  </aside>
</#macro>
