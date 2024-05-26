/*
  ==============================================================================

    This file contains the basic framework code for a JUCE plugin editor.

  ==============================================================================
*/

#pragma once

#include <JuceHeader.h>
#include "PluginProcessor.h"


//==============================================================================
/**
*/
class EffectsAudioProcessorEditor : public juce::AudioProcessorEditor
{
public:
    EffectsAudioProcessorEditor(EffectsAudioProcessor&);
    ~EffectsAudioProcessorEditor() override;

    //==============================================================================
    void paint(juce::Graphics&) override;
    void resized() override;

private:
    // This reference is provided as a quick way for your editor to
    // access the processor object that created it.
    EffectsAudioProcessor& audioProcessor;

    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    // Sliders declaration
    juce::Slider sliderChorusRate;
    juce::Slider sliderChorusDepth;
    juce::Slider sliderChorusCentreDelay;
    juce::Slider sliderChorusFeedback;
    juce::Slider sliderChorusMix;

    juce::Slider sliderPhaserRate;
    juce::Slider sliderPhaserDepth;
    juce::Slider sliderPhaserCentreFrequency;
    juce::Slider sliderPhaserFeedback;
    juce::Slider sliderPhaserMix;

    // Labels declaration
    juce::Label labelChorusRate;
    juce::Label labelChorusDepth;
    juce::Label labelChorusCentreDelay;
    juce::Label labelChorusFeedback;
    juce::Label labelChorusMix;

    juce::Label labelPhaserRate;
    juce::Label labelPhaserDepth;
    juce::Label labelPhaserCentreFrequency;
    juce::Label labelPhaserFeedback;
    juce::Label labelPhaserMix;

    // Attachments for linking GUI components to Processor's parameters
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> sliderChorusRateAttachment;
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> sliderChorusDepthAttachment;
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> sliderChorusCentreDelayAttachment;
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> sliderChorusFeedbackAttachment;
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> sliderChorusMixAttachment;

    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> sliderPhaserRateAttachment;
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> sliderPhaserDepthAttachment;
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> sliderPhaserCentreFrequencyAttachment;
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> sliderPhaserFeedbackAttachment;
    std::unique_ptr<juce::AudioProcessorValueTreeState::SliderAttachment> sliderPhaserMixAttachment;

    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

    JUCE_DECLARE_NON_COPYABLE_WITH_LEAK_DETECTOR(EffectsAudioProcessorEditor)
};