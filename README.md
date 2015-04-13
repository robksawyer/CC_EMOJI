# EMOJI

## Dependencies

- Monster Debugger: <https://code.google.com/p/monsterdebugger/>

## Asset SWCS

There are asset SWCs for different sizes of Emojis. These are helpful to quickly access certain sized Emojis from Flash.

Each SWC contains a set of Library items that have been exported as `flash.display.BitmapData` and named using the following convention. 

Emoji naming convention:
`Emoji_WidthxHeight_IconName`

Emoji naming convention examples:
`Emoji_20x20_104`

In Flash, after linking the SWC (via Actionscript Settings under Library Path) you can access each using the following command:

```
package
{
    import flash.display.BitmapData;
    import flash.display.Sprite;
 
    [SWF( width='600', height='400', frameRate='30', backgroundColor='#FFFFFF' )]
 
    public class App extends Sprite
    {
        public function App()
        {
            var emoji_20x20_104:BitmapData = new Emoji_20x20_104();
 
            addChild( emoji_20x20_104 );
        }
    }
}
```

## Resources
- Quick guide to creating and using SWCS: <http://code.tutsplus.com/tutorials/quick-tip-guide-to-creating-and-using-swcs--active-1211>