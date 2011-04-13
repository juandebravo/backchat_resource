require 'backchat_resource/models/channels'

module BackchatResource
  module Models
    class Channel < BackchatResource::Base
      
      # @see ReactiveResource
      singleton
      
      @old_uri = nil
      
      schema do
        string '_id', 'uri'
      end
      
      validates_presence_of :uri

      def initialize(*params)
        super
        if params.length == 1
          if params.is_a?(String)
            self.uri = params
          elsif params.is_a?(Channel)
            self.uri = params.uri
          elsif params.is_a?(BackchatUri)
            self.uri = params.dup
          end
        end
      end
      
      def serializable_hash(options = nil)
        # puts "          :old_channel => self.old_channel.to_s(true), #{@old_uri.inspect}"
        puts "Serializing channel " + self.uri.attributes.inspect# + ", \n" + self.uri.to_s # + ", \n" + self.uri.attributes.inspect
        
        old_channel_uri = @old_uri.to_s
        new_channel_uri = uri.to_s
        
        {
          :channel => new_channel_uri,
          :old_channel => (old_channel_uri.blank? ? nil : old_channel_uri)
        }
       end
      
      # Make a unique ID for this channel
      def id
        Digest::MD5.hexdigest(uri.to_s) rescue nil
      end
      
      # TODO:
      # Access properties on the URI as if they were on the Channel
      # set source [Source,Kind,string]
      # set kind [Kind,string]
      # target
      # 
      
      # @return [Source,nil]
      def source
        @source ||= Source.find_for_uri(uri)
      end
      
      def source=(val)
        uri.source = val
        @source = nil
      end
      
      # The message source-kind refines information of the source by defining a child-item
      # of the source... for instance, Twitter is the source, but Timeline is the kind
      # @return [Kind,nil]
      def kind
        @kind ||= Kind.find_for_uri(uri)
      end
      
      def kind=(val)
        uri.kind = val
        @kind = nil
      end
      
      # Overridable method- provides a rendered view of the target
      # For instance: twitter usernames are transformed from "backchatio" to "twitter.com/backchatio"
      # @returns [String]
      def display_target
        target
      end
      
      def target
        uri.target
      end
      
      def target=(val)
        uri.target = val
      end
      
      # @return [BackchatUri]
      def uri
        # return nil if @attributes.nil?
        @uri ||= BackchatUri.parse(@attributes["uri"])
      end
      
      def uri=(uri)
        super
        @old_uri = uri
        @uri = nil # clear cache
      end
            
      # def to_s
      #   uri.to_s
      # end
      
      # Override the destroy method as we need to do some custom param passing to make this work with the current API design.
      def destroy
        
      end
      
      # Build a new instance of Channel from a URL
      # @param [BackchatUri, string, Hash]
      # @return [Channel]
      def self.build_from_uri(doc)
        uri = nil
        if doc.is_a?(BackchatUri)
          uri = doc.dup
        elsif doc.is_a?(String)
          uri = doc
        elsif doc.is_a?(Hash)
          # A hash of URLs
          #{\"bare_uri\":\"{channel}://{host}\",\"full_uri\":\"smtp://adam.mojolly-crew\"}
          uri = doc["uri"]
        else
          raise "Expected an input of a String or Hash, got #{doc.class}"
        end
        (self.get_channel_class(uri)).new(:uri => uri)
      end

      def self.element_path(id, prefix_options = {}, query_options = nil)
        prefix_options, query_options = split_options(prefix_options) if query_options.nil?
        "#{self.site}#{BackchatResource::CONFIG['api']['message_channel_path']}index.#{self.format.extension}#{query_string(query_options)}"
      end
            
      def self.collection_path(prefix_options = {}, query_options = nil)
        prefix_options, query_options = split_options(prefix_options) if query_options.nil?
        "#{self.site}#{BackchatResource::CONFIG['api']['message_channel_path']}index.#{self.format.extension}#{query_string(query_options)}"
      end
            
      protected
      
      # @param [String] URI of channel to insepct and return a matching ChannelKind::Channel class
      # @return [Channel] a subclass of the Channel class that provides extra functionality for the source/kind
      def self.get_channel_class(*args)
        if args.length == 1
          source = BackchatUri.parse(args[0]).attributes["source"]["_id"].upcase
          kind = BackchatUri.parse(args[0]).attributes["kind"]["_id"].upcase
        else
          source = args[0].upcase
          kind = args[1].upcase rescue nil
        end
        
        case source
        when "WEBFEED"
          return Channels::Webfeed
        when "TWITTER"
          case kind
          when "TIMELINE"
            return Channels::TwitterTimeline
          when "OAUTH"
            return Channels::TwitterAccount
          end
        when "EMAIL"
          case kind
          when "SMTP"
            return Channels::EmailDropbox
          when "ACCOUNT"
            return Channels::EmailAccount
          end
        end

        Channel
      end
   
     
    end
  end
end