module WillPaginate
  # = Global options for pagination helpers
  #
  # Options for pagination helpers are optional and get their default values from the
  # WillPaginate::ViewHelpers.pagination_options hash. You can write to this hash to
  # override default options on the global level:
  #
  #   WillPaginate::ViewHelpers.pagination_options[:prev_label] = 'Previous page'
  #
  # By putting this into your environment.rb you can easily localize link texts to previous
  # and next pages, as well as override some other defaults to your liking.
  module ViewHelpers
    # default options that can be overriden on the global level
    @@pagination_options = { :class => 'pagination',
          :prev_label   => '&laquo; Previous',
          :next_label   => 'Next &raquo;',
          :inner_window => 4, # links around the current page
          :outer_window => 1, # links around beginning and end
          :separator    => ' ', # single space is friendly to spiders and non-graphic browsers
          :param_name   => :page,
          :remote_options => {},
          :remote_html_options => {}
          }
    mattr_reader :pagination_options

    # Renders Digg-style pagination. (We know you wanna!)
    # Returns nil if there is only one page in total (can't paginate that).
    # 
    # Options for will_paginate view helper:
    # 
    #   class:        CSS class name for the generated DIV (default "pagination")
    #   prev_label:   default '&laquo; Previous',
    #   next_label:   default 'Next &raquo;',
    #   inner_window: how many links are shown around the current page, defaults to 4
    #   outer_window: how many links are around the first and the last page, defaults to 1
    #   separator:    string separator for page HTML elements, default " " (single space)
    #   param_name:   parameter name for page number in URLs, defaults to "page"
    #   remote_options: options for link_to_remote. If not empty you get a link_to_remote with these options instead of the classic link. default is empty.
    #   remote_html_options: html_options for link_to_remote, default is empty.
    #
    # All extra options are passed to the generated container DIV, so eventually
    # they become its HTML attributes.
    #
    def will_paginate(entries = @entries, options = {})
      return unless entries.respond_to? :page_count
      total_pages = entries.page_count

      if total_pages > 1
        options = options.symbolize_keys.reverse_merge(pagination_options)
        page =  entries.current_page
        
        inner_window, outer_window = options.delete(:inner_window).to_i, options.delete(:outer_window).to_i
        param = Hash.new
        param[:param_name] = options.delete :param_name
        param[:remote_options] = options.delete :remote_options
        param[:remote_html_options] = options.delete :remote_html_options
        min = page - inner_window
        max = page + inner_window
        # adjust lower or upper limit if other is out of bounds
        if max > total_pages then min -= max - total_pages
        elsif min < 1  then max += 1 - min
        end
        
        current   = min..max
        beginning = 1..(1 + outer_window)
        tail      = (total_pages - outer_window)..total_pages
        visible   = [beginning, current, tail].map(&:to_a).flatten.sort.uniq
        links, prev = [], 0

        visible.each do |n|
          next if n < 1
          break if n > total_pages

          unless n - prev > 1
            prev = n
            links << page_link_or_span((n != page ? n : nil), 'current', n, param)
          else
            # ellipsis represents the gap between windows
            prev = n - 1
            links << '...'
            redo
          end
        end
        
        # next and previous buttons
        links.unshift page_link_or_span(entries.previous_page, 'disabled', options.delete(:prev_label), param)
        links.push    page_link_or_span(entries.next_page,     'disabled', options.delete(:next_label), param)
        
        content_tag :div, links.join(options.delete(:separator)), options
      end
    end
    
  protected

    def page_link_or_span(page, span_class, text, param)
      unless page
        content_tag :span, text, :class => span_class
      else
        # page links should preserve GET parameters, so we merge params
        if param[:remote_options].empty?
          link_to text, params.merge(param[:param_name].to_sym => (page !=1 ? page : nil))
        else
          # Merge params and put page number even if page is 1. So if you have multiple ajax will_paginate on the
          # same action, you know which one you have to render, ex :
          # format.js {
          #   if params[:page_line_items]
          #      render :partial => "line_items"
          #   elsif params[:page_packages]
          #      render :partial => "packages"
          #   end
          #  }
          #param[:remote_options][:url] = {:params => params.merge(param[:param_name].to_sym => page)}
          param[:remote_options][:url] = refresh_comments_path(:comments_page => page, :model_type => param[:remote_options][:model_type], :model_id => param[:remote_options][:model_id])
          #param[:remote_options][:before] = "$('message').update('Refreshing comments...')", 
          #param[:remote_options][:failure] = "$('message').update('There was a problem refreshing the  comments.')"
          #param[:remote_options][:success] = "$('message').update(''); "
          # If javascript is disabled, you'll still have your pagination working
          param[:remote_html_options][:href] = url_for(params.merge(param[:param_name].to_sym => (page !=1 ? page : nil)))
          link_to_remote text, param[:remote_options], param[:remote_html_options]
        end
      end
    end
  end
end
