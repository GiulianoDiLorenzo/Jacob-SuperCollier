/*
  ==============================================================================

    This file contains the basic framework code for a JUCE plugin processor.

  ==============================================================================
*/

#include "PluginProcessor.h"
#include "PluginEditor.h"

//==============================================================================
EffectsAudioProcessor::EffectsAudioProcessor()
#ifndef JucePlugin_PreferredChannelConfigurations
     : AudioProcessor (BusesProperties()
                     #if ! JucePlugin_IsMidiEffect
                      #if ! JucePlugin_IsSynth
                       .withInput  ("Input",  juce::AudioChannelSet::stereo(), true)
                      #endif
                       .withOutput ("Output", juce::AudioChannelSet::stereo(), true)
                     #endif
                       )
    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    
    // Instatiation of the AudioProcessorValueTreeState in the constructor
    , apvts(*this, nullptr, "Parameters", createParameters())

    // Instatiation of the chorus in the constructor
    , chorus()

    // Instatiation of the phaser in the constructor
    , phaser()

    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#endif
{
    // OSC listeners
    ds.bindToPort(57120, "127.0.0.1");
    if (!connectToSocket(ds))
        showConnectionErrorMessage("Error");

    juce::OSCReceiver::addListener(this, "/Effects_Values");        // listener
    juce::Logger::writeToLog("MainComponent constructed!");

}



EffectsAudioProcessor::~EffectsAudioProcessor()
{
}

//==============================================================================
const juce::String EffectsAudioProcessor::getName() const
{
    return JucePlugin_Name;
}

bool EffectsAudioProcessor::acceptsMidi() const
{
   #if JucePlugin_WantsMidiInput
    return true;
   #else
    return false;
   #endif
}

bool EffectsAudioProcessor::producesMidi() const
{
   #if JucePlugin_ProducesMidiOutput
    return true;
   #else
    return false;
   #endif
}

bool EffectsAudioProcessor::isMidiEffect() const
{
   #if JucePlugin_IsMidiEffect
    return true;
   #else
    return false;
   #endif
}

double EffectsAudioProcessor::getTailLengthSeconds() const
{
    return 0.0;
}

int EffectsAudioProcessor::getNumPrograms()
{
    return 1;   // NB: some hosts don't cope very well if you tell them there are 0 programs,
                // so this should be at least 1, even if you're not really implementing programs.
}

int EffectsAudioProcessor::getCurrentProgram()
{
    return 0;
}

void EffectsAudioProcessor::setCurrentProgram (int index)
{
}

const juce::String EffectsAudioProcessor::getProgramName (int index)
{
    return {};
}

void EffectsAudioProcessor::changeProgramName (int index, const juce::String& newName)
{
}

//==============================================================================
void EffectsAudioProcessor::prepareToPlay (double sampleRate, int samplesPerBlock)
{
    // Use this method as the place to do any pre-playback
    // initialisation that you need..
    
    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    
    // DSP chorus preparation with ProcessSpec component
    lastSampleRate = (float) sampleRate;
    juce::dsp::ProcessSpec spec;

    // Specifications need sampleRate, maximumBlockSize, numChannels
    spec.sampleRate = sampleRate;
    spec.maximumBlockSize = samplesPerBlock;
    spec.numChannels = getTotalNumOutputChannels();
    
    // DSP methods of initialisation
    chorus.prepare(spec);
    chorus.reset();
    phaser.prepare(spec);
    phaser.reset();
    
    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
}

void EffectsAudioProcessor::releaseResources()
{
    // When playback stops, you can use this as an opportunity to free up any
    // spare memory, etc.
}

#ifndef JucePlugin_PreferredChannelConfigurations
bool EffectsAudioProcessor::isBusesLayoutSupported (const BusesLayout& layouts) const
{
  #if JucePlugin_IsMidiEffect
    juce::ignoreUnused (layouts);
    return true;
  #else
    // This is the place where you check if the layout is supported.
    // In this template code we only support mono or stereo.
    // Some plugin hosts, such as certain GarageBand versions, will only
    // load plugins that support stereo bus layouts.
    if (layouts.getMainOutputChannelSet() != juce::AudioChannelSet::mono()
     && layouts.getMainOutputChannelSet() != juce::AudioChannelSet::stereo())
        return false;

    // This checks if the input layout matches the output layout
   #if ! JucePlugin_IsSynth
    if (layouts.getMainOutputChannelSet() != layouts.getMainInputChannelSet())
        return false;
   #endif

    return true;
  #endif
}
#endif

void EffectsAudioProcessor::processBlock (juce::AudioBuffer<float>& buffer, juce::MidiBuffer& midiMessages)
{
    juce::ScopedNoDenormals noDenormals;
    auto totalNumInputChannels  = getTotalNumInputChannels();
    auto totalNumOutputChannels = getTotalNumOutputChannels();

    // In case we have more outputs than inputs, this code clears any output
    // channels that didn't contain input data, (because these aren't
    // guaranteed to be empty - they may contain garbage).
    // This is here to avoid people getting screaming feedback
    // when they first compile a plugin, but obviously you don't need to keep
    // this code if your algorithm always overwrites all the output channels.
    for (auto i = totalNumInputChannels; i < totalNumOutputChannels; ++i)
        buffer.clear (i, 0, buffer.getNumSamples());

    // This is the place where you'd normally do the guts of your plugin's
    // audio processing...
    // Make sure to reset the state if your inner loop is processing
    // the samples and the outer loop is handling the channels.
    // Alternatively, you can process the samples with the channels
    // interleaved by keeping the same state.
    for (int channel = 0; channel < totalNumInputChannels; ++channel)
    {
        auto* channelData = buffer.getWritePointer (channel);

        // ..do something to the data...
    }

    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    
    // Input AudioBlock buffer
    juce::dsp::AudioBlock <float> block(buffer);    // AudioBlock component for processing the input buffer

    juce::AudioBuffer<float> bufferChorus = buffer;
    juce::AudioBuffer<float> bufferPhaser = buffer;
    juce::dsp::AudioBlock<float> blockChorus(bufferChorus);
    juce::dsp::AudioBlock<float> blockPhaser(bufferPhaser);
    
    // Reading the necessary parameters of the AudioProcessorValueTreeState
    chorusRate = *apvts.getRawParameterValue("ID_ChorusRate");      // getRawParameterValue returns the pointer to the parameter
    chorusDepth = *apvts.getRawParameterValue("ID_ChorusDepth");
    chorusCentreDelay = *apvts.getRawParameterValue("ID_ChorusCentreDelay");
    chorusFeedback = *apvts.getRawParameterValue("ID_ChorusFeedback");
    chorusMix = *apvts.getRawParameterValue("ID_ChorusMix");

    phaserRate = *apvts.getRawParameterValue("ID_PhaserRate");
    phaserDepth = *apvts.getRawParameterValue("ID_PhaserDepth");
    phaserCentreFrequency = *apvts.getRawParameterValue("ID_PhaserCentreFrequency");
    phaserFeedback = *apvts.getRawParameterValue("ID_PhaserFeedback");
    phaserMix = *apvts.getRawParameterValue("ID_PhaserMix");


    // Updating the chorus state
    chorus.setRate(chorusRate);
    chorus.setDepth(chorusDepth);
    chorus.setCentreDelay(chorusCentreDelay);
    chorus.setFeedback(chorusFeedback);
    chorus.setMix(chorusMix);
    
    // Updating the phaser state
    phaser.setRate(phaserRate);
    phaser.setDepth(phaserDepth);
    phaser.setCentreFrequency(phaserCentreFrequency);
    phaser.setFeedback(phaserFeedback);
    phaser.setMix(phaserMix);

    // Applying chorus, phaser on input samples
    chorus.process(juce::dsp::ProcessContextReplacing<float>(blockChorus));
    phaser.process(juce::dsp::ProcessContextReplacing<float>(blockPhaser));

    // Summing original buffer (80%) with chorus (10%) and phaser (10%)
    for (int i = 0; i < totalNumOutputChannels; i++) {
        auto outputBuffer = buffer.getWritePointer(i);          // outputBuffer is the pointer for the output samples
        for (int j = 0; j < buffer.getNumSamples(); j++)
            outputBuffer[j] = (float)(0.8 * block.getSample(i, j) + 0.1 * blockChorus.getSample(i, j) + 0.1 * blockPhaser.getSample(i, j));
    }
    
    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

}

//==============================================================================
bool EffectsAudioProcessor::hasEditor() const
{
    return true; // (change this to false if you choose to not supply an editor)
}

juce::AudioProcessorEditor* EffectsAudioProcessor::createEditor()
{
    return new EffectsAudioProcessorEditor (*this);
}

//==============================================================================
void EffectsAudioProcessor::getStateInformation (juce::MemoryBlock& destData)
{
    // You should use this method to store your parameters in the memory block.
    // You could do that either as raw data, or use the XML or ValueTree classes
    // as intermediaries to make it easy to save and load complex data.
}

void EffectsAudioProcessor::setStateInformation (const void* data, int sizeInBytes)
{
    // You should use this method to restore your parameters from this memory block,
    // whose contents will have been created by the getStateInformation() call.
}

//==============================================================================
// This creates new instances of the plugin..
juce::AudioProcessor* JUCE_CALLTYPE createPluginFilter()
{
    return new EffectsAudioProcessor();
}

// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

// Definition and linking of parameters
juce::AudioProcessorValueTreeState::ParameterLayout EffectsAudioProcessor::createParameters()
{
    std::vector <std::unique_ptr <juce::RangedAudioParameter>> parameters;      // parameters is a vector of unique pointers to RangedAudioParameters

    parameters.push_back(std::make_unique<juce::AudioParameterFloat>("ID_ChorusRate", "Chorus Rate", 0.0f, 20.0f, 1.0f));     // ID, name, min_value, max_value, default_value
    parameters.push_back(std::make_unique<juce::AudioParameterFloat>("ID_ChorusDepth", "Chorus Depth", 0.0f, 1.0f, 0.5f));
    parameters.push_back(std::make_unique<juce::AudioParameterFloat>("ID_ChorusCentreDelay", "Chorus Centre Delay", 1.0, 99.0, 50.0));
    parameters.push_back(std::make_unique<juce::AudioParameterFloat>("ID_ChorusFeedback", "Chorus Feedback", -1.0f, 1.0f, 0.0f));
    parameters.push_back(std::make_unique<juce::AudioParameterFloat>("ID_ChorusMix", "Chorus Mix", 0.0f, 1.0f, 1.0f));
    
    parameters.push_back(std::make_unique<juce::AudioParameterFloat>("ID_PhaserRate", "Phaser Rate", 0.0f, 15.0f, 1.5f));
    parameters.push_back(std::make_unique<juce::AudioParameterFloat>("ID_PhaserDepth", "Phaser Depth", 0.0f, 1.0f, 0.5f));
    parameters.push_back(std::make_unique<juce::AudioParameterFloat>("ID_PhaserCentreFrequency", "Phaser Centre Frequency", 0.0f, 5000.0f, 200.0f));
    parameters.push_back(std::make_unique<juce::AudioParameterFloat>("ID_PhaserFeedback", "Phaser Feedback", -1.0f, 1.0f, 0.0f));
    parameters.push_back(std::make_unique<juce::AudioParameterFloat>("ID_PhaserMix", "Phaser Mix", 0.0f, 1.0f, 1.0f));
    
    return {parameters.begin(), parameters.end()};
}

// Definition of incoming OSC messages response
void EffectsAudioProcessor::oscMessageReceived(const juce::OSCMessage& message)
{
    juce::Logger::writeToLog("OSC Message detected");       // checking incoming OSC messages

    // Reading the phaser rate from argument at 6 (if not NaN)
    if (!std::isnan(message[6].getFloat32())) {
        phaserRate = message[6].getFloat32();       // getFloat32() converts a juce::OSCMessage into a float
        juce::Logger::writeToLog("phaserRate : " + juce::String(message[6].getFloat32()));
    }
    
    // Reading the chorus feedback from argument at 8 (if not NaN)
    if (!std::isnan(message[8].getFloat32())) {
        chorusFeedback = message[8].getFloat32();
        juce::Logger::writeToLog("chorusFeedback : " + juce::String(message[8].getFloat32()));
    }

    // Displaying the incoming OSC messages
    juce::String address = message.getAddressPattern().toString();
    juce::String args;
    for (int i = 0; i < message.size(); ++i) {
        args += juce::String(message[i].getFloat32()) + " ";
    }
    juce::Logger::writeToLog("Received OSC Message: " + address + " " + args);
}

// Error message display
void EffectsAudioProcessor::showConnectionErrorMessage(const juce::String& messageText)
{
    juce::AlertWindow::showMessageBoxAsync(juce::AlertWindow::WarningIcon, "Connection error", messageText, "OK");
}

// <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

