require "json"
require "auto_constructor"

module AutoJson
  VERSION = "0.1"

  macro included
    include AutoConstructor

    {% if !@type.constant :JSON_OPTIONS %}
      JSON_OPTIONS = {} of Nil => Nil
    {% end %}

    macro json_options(**opts)
      \{%
        JSON_OPTIONS[:strict] = opts[:strict]
        JSON_OPTIONS[:emit_nulls] = opts[:emit_nulls]
      %}
    end

    macro finished
      def initialize(%pull : ::JSON::PullParser)
        \{% ready_fields = 0 %}
        \{% for field in AUTO_CONSTRUCTOR_FIELDS %}
          \{% if field[:json] != false && field[:serialize] != false %}
            \{% ready_fields = ready_fields + 1 %}
          \{% end %}
          _\{{field[:name].id}} = nil
          _found\{{field[:name].id}} = false
        \{% end %}

        %pull.read_object do |key|
          \{% if ready_fields > 0 %}
          case key
            \{% for field in AUTO_CONSTRUCTOR_FIELDS %}
              \{% if field[:json] != false && field[:serialize] != false %}
                when \{{(field[:json_key] || field[:key] || field[:name]).id.stringify}}
                  _found\{{field[:name].id}} = true

                  _\{{field[:name].id}} =
                    \{% if field[:default] != nil %} %pull.read_null_or { \{% end %}
                      \{% if field[:json_converter] || field[:converter] %}
                        \{{field[:json_converter] || field[:converter]}}.from_json(%pull)
                      \{% else %}
                        (\{{field[:type].id}}).new(%pull)
                      \{% end %}
                    \{% if field[:default] != nil %} } \{% end %}
              \{% end %}
            \{% end %}
          else
            \{% if JSON_OPTIONS[:strict] %}
              raise JSON::ParseException.new("unknown json attribute: #{key}", 0, 0)
            \{% else %}
              %pull.skip
            \{% end %}
          end
          \{% else %}
            %pull.skip
          \{% end %}
        end

        \{% for field in AUTO_CONSTRUCTOR_FIELDS %}
          \{% if field[:default] == nil %}
            if _\{{field[:name].id}}.is_a?(Nil) && !_found\{{field[:name].id}} && !Union(\{{field[:type].id}}).nilable?
              raise JSON::ParseException.new("missing json attribute: #{\{{(field[:json_key] || field[:key] || field[:name]).id.stringify}}}", 0, 0)
            end
          \{% end %}
        \{% end %}

        \{% for field in AUTO_CONSTRUCTOR_FIELDS %}
          \{% if field[:nilable] %}
            \{% if field[:default] != nil %}
              @\{{field[:name].id}} = _found\{{field[:name].id}} ? _\{{field[:name].id}} : \{{field[:default]}}
            \{% else %}
              @\{{field[:name].id}} = _\{{field[:name].id}}
            \{% end %}
          \{% elsif field[:default] != nil %}
            @\{{field[:name].id}} = _\{{field[:name].id}}.is_a?(Nil) ? \{{field[:default]}} : _\{{field[:name].id}}
          \{% else %}
            @\{{field[:name].id}} = (_\{{field[:name].id}}).as(\{{field[:type].id}})
          \{% end %}
        \{% end %}

        \{% for ai in AFTER_INITIALIZE %} \{{ ai.id }} \{% end %}
      end

      def to_json(json : JSON::Builder)
        json.object do
          \{% for field in AUTO_CONSTRUCTOR_FIELDS %}
            \{% if field[:json] != false && field[:serialize] != false %}
              _\{{field[:name].id}} = @\{{field[:name].id}}

              \{% unless (JSON_OPTIONS[:emit_nulls] || field[:json_emit_null] || field[:emit_null]) %}
                unless _\{{field[:name].id}}.is_a?(Nil)
              \{% end %}

                json.field(\{{(field[:json_key] || field[:key] || field[:name]).id.stringify}}) do
                  \{% if field[:json_converter] || field[:converter] %}
                    if _\{{field[:name].id}}
                      \{{ field[:json_converter] || field[:converter] }}.to_json(_\{{field[:name].id}}, json)
                    else
                      nil.to_json(json)
                    end
                  \{% else %}
                    _\{{field[:name].id}}.to_json(json)
                  \{% end %}
                end

              \{{ (JSON_OPTIONS[:emit_nulls] || field[:json_emit_null] || field[:emit_null]) ? "".id : "end".id }}
            \{% end %}
          \{% end %}
        end
      end
    end

    def pack(io : IO)
      to_json(io)
    end

    def pack
      to_json
    end

    def self.from_json(io : IO)
      self.new(::JSON::PullParser.new(io))
    end

    def self.unpack(io : IO)
      from_json(io)
    end

    def self.unpack(str : String)
      unpack IO::Memory.new(str)
    end
  end
end
