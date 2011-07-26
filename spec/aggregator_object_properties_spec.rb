require "jsduck/aggregator"
require "jsduck/source_file"

describe JsDuck::Aggregator do

  def parse(string)
    agr = JsDuck::Aggregator.new
    agr.aggregate(JsDuck::SourceFile.new(string))
    agr.result
  end

  shared_examples_for "object with properties" do
    it "has name" do
      @obj[:name].should == "coord"
    end

    it "has type" do
      @obj[:type].should == "Object"
    end

    it "has doc" do
      @obj[:doc].should == "Geographical coordinates"
    end

    it "contains 2 properties" do
      @obj[:properties].length.should == 2
    end

    describe "first property" do
      before do
        @prop = @obj[:properties][0]
      end

      it "has name without namespace" do
        @prop[:name].should == "lat"
      end

      it "has type" do
        @prop[:type].should == "Object"
      end

      it "has doc" do
        @prop[:doc].should == "Latitude"
      end

      it "contains 2 subproperties" do
        @prop[:properties].length.should == 2
      end

      describe "first subproperty" do
        it "has name without namespace" do
          @prop[:properties][0][:name].should == "numerator"
        end
      end

      describe "second subproperty" do
        it "has name without namespace" do
          @prop[:properties][1][:name].should == "denominator"
        end
      end
    end

    describe "second property" do
      before do
        @prop = @obj[:properties][1]
      end

      it "has name without namespace" do
        @prop[:name].should == "lng"
      end

      it "has type" do
        @prop[:type].should == "Number"
      end

      it "has doc" do
        @prop[:doc].should == "Longitude"
      end
    end
  end

  describe "method parameter with properties" do
    before do
      @doc = parse(<<-EOS)[0]
        /**
         * Some function
         * @param {Object} coord Geographical coordinates
         * @param {Object} coord.lat Latitude
         * @param {Number} coord.lat.numerator Numerator part of a fraction
         * @param {Number} coord.lat.denominator Denominator part of a fraction
         * @param {Number} coord.lng Longitude
         */
        function foo(x, y) {}
      EOS
    end

    it "is interpreted as single parameter" do
      @doc[:params].length.should == 1
    end

    describe "single param" do
      before do
        @obj = @doc[:params][0]
      end

      it_should_behave_like "object with properties"
    end
  end

  describe "event parameter with properties" do
    before do
      @doc = parse(<<-EOS)[0]
        /**
         * @event
         * Some event
         * @param {Object} coord Geographical coordinates
         * @param {Object} coord.lat Latitude
         * @param {Number} coord.lat.numerator Numerator part of a fraction
         * @param {Number} coord.lat.denominator Denominator part of a fraction
         * @param {Number} coord.lng Longitude
         */
        "foo"
      EOS
    end

    it "is interpreted as single parameter" do
      @doc[:params].length.should == 1
    end

    describe "single param" do
      before do
        @obj = @doc[:params][0]
      end

      it_should_behave_like "object with properties"
    end
  end

  describe "cfg with properties" do
    before do
      @doc = parse(<<-EOS)
        /**
         * @cfg {Object} coord Geographical coordinates
         * @cfg {Object} coord.lat Latitude
         * @cfg {Number} coord.lat.numerator Numerator part of a fraction
         * @cfg {Number} coord.lat.denominator Denominator part of a fraction
         * @cfg {Number} coord.lng Longitude
         */
      EOS
    end

    it "is interpreted as single config" do
      @doc.length.should == 1
    end

    describe "the config" do
      before do
        @obj = @doc[0]
      end

      it_should_behave_like "object with properties"
    end
  end

  describe "property with properties" do
    before do
      @doc = parse(<<-EOS)
        /**
         * @property {Object} coord Geographical coordinates
         * @property {Object} coord.lat Latitude
         * @property {Number} coord.lat.numerator Numerator part of a fraction
         * @property {Number} coord.lat.denominator Denominator part of a fraction
         * @property {Number} coord.lng Longitude
         */
      EOS
    end

    it "is interpreted as single property" do
      @doc.length.should == 1
    end

    describe "the property" do
      before do
        @obj = @doc[0]
      end

      it_should_behave_like "object with properties"
    end
  end
end
