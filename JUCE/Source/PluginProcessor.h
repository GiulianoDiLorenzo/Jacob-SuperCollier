/*
  ==============================================================================

    This file contains the basic framework code for a JUCE plugin processor.

  ==============================================================================
*/

#pragma once

#include <JuceHeader.h>
#include <cstdio>

//==============================================================================
/**
*/
class EffectsAudioProcessor : public juce::AudioProcessor
    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    // OSCReceiver inheritances
    , private juce::OSCReceiver, juce::OSCReceiver::ListenerWithOSCAddress<juce::OSCReceiver::MessageLoopCallback>

    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
{
public:
    //==============================================================================
    EffectsAudioProcessor();
    ~EffectsAudioProcessor() override;

    //==============================================================================
    void prepareToPlay(double sampleRate, int samplesPerBlock) override;
    void releaseResources() override;

#ifndef JucePlugin_PreferredChannelConfigurations
    bool isBusesLayoutSupported(const BusesLayout& layouts) const override;
#endif

    void processBlock(juce::AudioBuffer<float>&, juce::MidiBuffer&) override;

    //==============================================================================
    juce::AudioProcessorEditor* createEditor() override;
    bool hasEditor() const override;

    //==============================================================================
    const juce::String getName() const override;

    bool acceptsMidi() const override;
    bool producesMidi() const override;
    bool isMidiEffect() const override;
    double getTailLengthSeconds() const override;

    //==============================================================================
    int getNumPrograms() override;
    int getCurrentProgram() override;
    void setCurrentProgram(int index) override;
    const juce::String getProgramName(int index) override;
    void changeProgramName(int index, const juce::String& newName) override;

    //==============================================================================
    void getStateInformation(juce::MemoryBlock& destData) override;
    void setStateInformation(const void* data, int sizeInBytes) override;

    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    // AudioProcessValueTreeState class declaration for implementing Editor <-> Processor
    juce::AudioProcessorValueTreeState apvts;

    // Method for creating and associating all parameters of the plugin
    juce::AudioProcessorValueTreeState::ParameterLayout createParameters();

    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

private:
    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    // Filters declaration
    juce::dsp::Chorus<float> chorus;
    juce::dsp::Phaser<float> phaser;

    // Sample rate history
    float lastSampleRate;

    // Chorus parameters
    float chorusRate;
    float chorusDepth;
    float chorusCentreDelay;
    float chorusFeedback;
    float chorusMix;

    // Phaser parameters
    float phaserRate;
    float phaserDepth;
    float phaserCentreFrequency;
    float phaserFeedback;
    float phaserMix;

    // OSC receiver
    juce::DatagramSocket ds;

    void showConnectionErrorMessage(const juce::String& messageText);
    void oscMessageReceived(const juce::OSCMessage& message) override;    // virtual function from ListenerWithOSCAddress

    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    //==============================================================================
    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(EffectsAudioProcessor)
};