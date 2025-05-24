# Bets Feature Update - Interactive Bet Options

## Overview
The betting interface has been updated to make individual bet options (spread, total, winner) clickable and interactive. Users can now apply systems to specific bet types rather than just entire games.

## New Features

### 1. Clickable Bet Options
- Each cell in the betting grid (spread, total, winner) is now individually clickable
- Hover effects provide visual feedback when you move your mouse over options
- Click animations provide tactile feedback

### 2. System Application to Specific Bets
- Select a system from the dropdown at the top of the page
- Click on any specific bet option (e.g., "+5.0" for Indiana Pacers spread)
- A dialog will appear showing:
  - The game details
  - The specific bet option you selected
  - The system you're applying
  - System confidence percentage

### 3. Visual Indicators
- Hover state: Options glow with the primary color when hovered
- System applied: A small dot appears below bet options when a system is selected
- Clear labeling: Over/Under are marked with "O" and "U" in green/gray

## How to Use

1. **Select a System**: Use the dropdown menu at the top to choose a system
2. **Click a Bet Option**: Click on any spread, total, or winner option
3. **Review**: A dialog shows your selection details
4. **Test System**: Click "TEST SYSTEM" to see performance results
5. **Apply**: Choose to apply the system or discard

## User Experience Improvements

- **Clear Feedback**: Every interaction provides immediate visual feedback
- **Intuitive Design**: Click on exactly what you want to bet on
- **System Integration**: Seamlessly apply your betting systems to specific options
- **Performance Testing**: Test how your system performs on specific bet types

## Technical Details

- New `ClickableBetOption` widget handles individual bet cells
- `CompactBetCard` updated to use clickable options
- `BetsPage` handles bet option selection with new dialog system
- `SimpleSystemTestDialog` updated to show specific bet option details