/*
  ==============================================================================

    This file contains the basic framework code for a JUCE plugin editor.

  ==============================================================================
*/

#include "PluginProcessor.h"
#include "PluginEditor.h"

//==============================================================================
EffectsAudioProcessorEditor::EffectsAudioProcessorEditor (EffectsAudioProcessor& p)
    : AudioProcessorEditor (&p), audioProcessor (p)
{
    // Make sure that before the constructor has finished, you've set the
    // editor's size to whatever you need it to be.
    setSize(900, 600);

    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    
    // Sliders and labels description for parameter 1
    sliderChorusRate.setSliderStyle(juce::Slider::SliderStyle::RotaryHorizontalVerticalDrag);             // SliderStyle component
    sliderChorusRate.setTextBoxStyle(juce::Slider::TextEntryBoxPosition::TextBoxBelow, true, 100, 20);          // TextEntryBoxPosition component, read-only boolean, width, height
    sliderChorusRate.setRange(0.0, 20.0, 0.1);      // min, max, interval
    addAndMakeVisible(sliderChorusRate);            // making sliderChorusRate visible
    labelChorusRate.setText("Chorus Rate (Hz)", juce::dontSendNotification);            // label text, NotificationType component
    addAndMakeVisible(labelChorusRate);             // making label 1 visible

    // Sliders and labels description for parameter 2
    sliderChorusDepth.setSliderStyle(juce::Slider::SliderStyle::RotaryHorizontalVerticalDrag);
    sliderChorusDepth.setTextBoxStyle(juce::Slider::TextEntryBoxPosition::TextBoxBelow, true, 100, 20);
    sliderChorusDepth.setRange(0.0, 1.0, 0.1);
    addAndMakeVisible(sliderChorusDepth);
    labelChorusDepth.setText("Chorus Depth", juce::dontSendNotification);
    addAndMakeVisible(labelChorusDepth);

    // Sliders and labels description for parameter 3
    sliderChorusCentreDelay.setSliderStyle(juce::Slider::SliderStyle::RotaryHorizontalVerticalDrag);
    sliderChorusCentreDelay.setTextBoxStyle(juce::Slider::TextEntryBoxPosition::TextBoxBelow, true, 100, 20);
    sliderChorusCentreDelay.setRange(1.0, 100.0, 1.0);
    addAndMakeVisible(sliderChorusCentreDelay);
    labelChorusCentreDelay.setText("Chorus Centre Delay (ms)", juce::dontSendNotification);
    addAndMakeVisible(labelChorusCentreDelay);

    // Sliders and labels description for parameter 4
    sliderChorusFeedback.setSliderStyle(juce::Slider::SliderStyle::RotaryHorizontalVerticalDrag);
    sliderChorusFeedback.setTextBoxStyle(juce::Slider::TextEntryBoxPosition::TextBoxBelow, true, 100, 20);
    sliderChorusFeedback.setRange(-1.0, 1.0, 0.1);
    addAndMakeVisible(sliderChorusFeedback);
    labelChorusFeedback.setText("Chorus Feedback", juce::dontSendNotification);
    addAndMakeVisible(labelChorusFeedback);

    // Sliders and labels description for parameter 5
    sliderChorusMix.setSliderStyle(juce::Slider::SliderStyle::RotaryHorizontalVerticalDrag);
    sliderChorusMix.setTextBoxStyle(juce::Slider::TextEntryBoxPosition::TextBoxBelow, true, 100, 20);
    sliderChorusMix.setRange(0.0, 1.0, 0.1);
    addAndMakeVisible(sliderChorusMix);
    labelChorusMix.setText("Chorus Mix (%)", juce::dontSendNotification);
    addAndMakeVisible(labelChorusMix);

    // Sliders and labels description for parameter 6
    sliderPhaserRate.setSliderStyle(juce::Slider::SliderStyle::RotaryHorizontalVerticalDrag);
    sliderPhaserRate.setTextBoxStyle(juce::Slider::TextEntryBoxPosition::TextBoxBelow, true, 100, 20);
    sliderPhaserRate.setRange(0.0, 20.0, 0.1);
    addAndMakeVisible(sliderPhaserRate);
    labelPhaserRate.setText("Phaser Rate (Hz)", juce::dontSendNotification);
    addAndMakeVisible(labelPhaserRate);

    // Sliders and labels description for parameter 7
    sliderPhaserDepth.setSliderStyle(juce::Slider::SliderStyle::RotaryHorizontalVerticalDrag);
    sliderPhaserDepth.setTextBoxStyle(juce::Slider::TextEntryBoxPosition::TextBoxBelow, true, 100, 20);
    sliderPhaserDepth.setRange(0.0, 1.0, 0.1);
    addAndMakeVisible(sliderPhaserDepth);
    labelPhaserDepth.setText("Phaser Depth", juce::dontSendNotification);
    addAndMakeVisible(labelPhaserDepth);

    // Sliders and labels description for parameter 8
    sliderPhaserCentreFrequency.setSliderStyle(juce::Slider::SliderStyle::RotaryHorizontalVerticalDrag);
    sliderPhaserCentreFrequency.setTextBoxStyle(juce::Slider::TextEntryBoxPosition::TextBoxBelow, true, 100, 20);
    sliderPhaserCentreFrequency.setRange(0.0, 5000.0, 10.0);
    addAndMakeVisible(sliderPhaserCentreFrequency);
    labelPhaserCentreFrequency.setText("Phaser Centre Frequency (Hz)", juce::dontSendNotification);
    addAndMakeVisible(labelPhaserCentreFrequency);

    // Sliders and labels description for parameter 9
    sliderPhaserFeedback.setSliderStyle(juce::Slider::SliderStyle::RotaryHorizontalVerticalDrag);
    sliderPhaserFeedback.setTextBoxStyle(juce::Slider::TextEntryBoxPosition::TextBoxBelow, true, 100, 20);
    sliderPhaserFeedback.setRange(-1.0, 1.0, 0.1);
    addAndMakeVisible(sliderPhaserFeedback);
    labelPhaserFeedback.setText("Phaser Feedback", juce::dontSendNotification);
    addAndMakeVisible(labelPhaserFeedback);

    // Sliders and labels description for parameter 10
    sliderPhaserMix.setSliderStyle(juce::Slider::SliderStyle::RotaryHorizontalVerticalDrag);
    sliderPhaserMix.setTextBoxStyle(juce::Slider::TextEntryBoxPosition::TextBoxBelow, true, 100, 20);
    sliderPhaserMix.setRange(0.0, 100.0, 0.1);
    addAndMakeVisible(sliderPhaserMix);
    labelPhaserMix.setText("Phaser Mix (%)", juce::dontSendNotification);
    addAndMakeVisible(labelPhaserMix);

    // Attachments linking
    sliderChorusRateAttachment = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(audioProcessor.apvts, "ID_ChorusRate", sliderChorusRate);       // AudioProcessorValueTreeState inside the Processor, parameter ID (from ParameterLayout), GUI slider
    sliderChorusDepthAttachment = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(audioProcessor.apvts, "ID_ChorusDepth", sliderChorusDepth);
    sliderChorusCentreDelayAttachment = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(audioProcessor.apvts, "ID_ChorusCentreDelay", sliderChorusCentreDelay);
    sliderChorusFeedbackAttachment = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(audioProcessor.apvts, "ID_ChorusFeedback", sliderChorusFeedback);
    sliderChorusMixAttachment = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(audioProcessor.apvts, "ID_ChorusMix", sliderChorusMix);

    sliderPhaserRateAttachment = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(audioProcessor.apvts, "ID_PhaserRate", sliderPhaserRate);       // AudioProcessorValueTreeState inside the Processor, parameter ID (from ParameterLayout), GUI slider
    sliderPhaserDepthAttachment = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(audioProcessor.apvts, "ID_PhaserDepth", sliderPhaserDepth);
    sliderPhaserCentreFrequencyAttachment = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(audioProcessor.apvts, "ID_PhaserCentreFrequency", sliderPhaserCentreFrequency);
    sliderPhaserFeedbackAttachment = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(audioProcessor.apvts, "ID_PhaserFeedback", sliderPhaserFeedback);
    sliderPhaserMixAttachment = std::make_unique<juce::AudioProcessorValueTreeState::SliderAttachment>(audioProcessor.apvts, "ID_PhaserMix", sliderPhaserMix);

    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
}

EffectsAudioProcessorEditor::~EffectsAudioProcessorEditor()
{
}

//==============================================================================
void EffectsAudioProcessorEditor::paint (juce::Graphics& g)
{
    // (Our component is opaque, so we must completely fill the background with a solid colour)
    g.fillAll (getLookAndFeel().findColour (juce::ResizableWindow::backgroundColourId));

    g.setColour (juce::Colours::white);
    g.setFont (15.0f);
    g.drawFittedText (" ", getLocalBounds(), juce::Justification::centred, 1);
}

void EffectsAudioProcessorEditor::resized()
{
    // This is generally where you'll want to lay out the positions of any
    // subcomponents in your editor..
    
    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
    
    // Specifying all GUI components location
    labelChorusRate.setBounds(5, 50, 150, 20);         // setBounds needs x_position, y_position, width, height  
    sliderChorusRate.setBounds(10, 80, 100, 100);

    labelChorusDepth.setBounds(155, 50, 150, 20); 
    sliderChorusDepth.setBounds(150, 80, 100, 100);

    labelChorusCentreDelay.setBounds(275, 50, 150, 20);
    sliderChorusCentreDelay.setBounds(300, 80, 100, 100);

    labelChorusFeedback.setBounds(445, 50, 150, 20);
    sliderChorusFeedback.setBounds(450, 80, 100, 100);

    labelChorusMix.setBounds(600, 50, 150, 20);
    sliderChorusMix.setBounds(600, 80, 100, 100);

    labelPhaserRate.setBounds(5, 220, 150, 20);
    sliderPhaserRate.setBounds(10, 250, 100, 100);

    labelPhaserDepth.setBounds(155, 220, 150, 20);
    sliderPhaserDepth.setBounds(150, 250, 100, 100);

    labelPhaserCentreFrequency.setBounds(275, 220, 150, 20);
    sliderPhaserCentreFrequency.setBounds(300, 250, 100, 100);

    labelPhaserFeedback.setBounds(445, 220, 150, 20);
    sliderPhaserFeedback.setBounds(450, 250, 100, 100);

    labelPhaserMix.setBounds(600, 220, 150, 20);
    sliderPhaserMix.setBounds(600, 250, 100, 100);

    // <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
}
