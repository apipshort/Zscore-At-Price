//+------------------------------------------------------------------+
//|   Last edit: Oct 10 2012                  00z At Price.mq4       |
//|   A Chart Window Indicator.                                      |
//|   Shows Standardized Z Score on Bid Price.                       |
//|   Outputs as Text at the Bid Line. Works on any TF.              |
//|   Note: You MUST Set the SMA Period equal to the BB system!      |
//|   Use some Chart Shift to show Indicator Output.                 |
//+------------------------------------------------------------------+
#property copyright "© 2011 apipshort"
#property link "http://www.forexfactory.com/showthread.php?t=389386"
#property indicator_chart_window

extern string   Make_Sure = "Set SMA Period equal to BB system!";
extern string  SMA_Period = "Default Simple MA Period = 20";
extern int      smaPeriod = 20; // 20
extern int       fontSize = 12; // 12
extern string ScreenColor = "Dark Screen = 1, Light = 2";
extern int        colorBG = 1;  // 1

string font = "Arial";
string text = "z-score SMA Period = ";
string padding;  // offsetting text from Bar 0 with some left padding
color  c_1, c1_2, c2_3, c3_4,c, c_4;

//+------------------------------------------------------------------+

void SetColors(int backGround)
   { // modify as wanted. each color represents one Standard Deviation unit.
   switch (backGround)
      {
      case 1: c_1= White; c1_2= HotPink; c2_3= Lime; c3_4= Yellow; c_4= Red; return(0);
      case 2: c_1= Black; c1_2= Blue; c2_3= Green; c3_4= Orange; c_4= Red; return(0);

      default:     return(0);
      }
   } // end void SetColors(int backGround)

//+------------------------------------------------------------------+

int init()
   {
   //if found label "00z_Mark" read SMA Period from there
   int getSMA = StrToInteger(ObjectDescription("00z_Mark"));
   if(getSMA > 2) smaPeriod = getSMA;

   //if found label "bg_Mark" read BG selection from there
   int getBG = StrToInteger(ObjectDescription("bg_Mark"));
   if(getBG > 0) colorBG = getBG;
   if(colorBG < 1 || colorBG > 2) colorBG = 1;
   SetColors(colorBG);

   text = StringConcatenate(text, smaPeriod);
   ObjectCreate(text, OBJ_TEXT,0,0,0);

   padding = "                               ";  // adjust as fit
   //........"..............................."; place holder only

   return(0);
   } // end int init()

//+------------------------------------------------------------------+

int deinit()
   {
   ObjectDelete(text);
   return(0);
   } // end int deinit()

//+------------------------------------------------------------------+

int start()
   { // standardized z-score  = ( Bid - mean ) / sigma. see further down also

   double zScore  = ( Bid - iMA(NULL,0, smaPeriod, 0,MODE_SMA,PRICE_CLOSE,0))
                      / iStdDev(NULL,0, smaPeriod, 0,MODE_SMA,PRICE_CLOSE,0);

   double m = MathAbs(zScore);
   if ( m <  1)    color clr = c_1;
   if ( m >= 1 && m < 2) clr = c1_2;
   if ( m >= 2 && m < 3) clr = c2_3;
   if ( m >= 3 && m < 4) clr = c3_4;
   if ( m >= 4)          clr = c_4;
   string sign = "";
   if (zScore > 0) sign = "+";

      ObjectMove(text, 0, Time[0], Bid);
   ObjectSetText(text, StringConcatenate(padding, sign,
                       DoubleToStr(zScore, 2), "   ",
                       DoubleToStr(Bid, Digits-1)),
                       fontSize, font, clr);

   return(0);
   } // end int start()

//+--------------------------------EOP-------------------------------+

/*
// more explicit code, 3 lines.

double mean    =     iMA(NULL,0, smaPeriod, 0,MODE_SMA,PRICE_CLOSE,0);
double sigma   = iStdDev(NULL,0, smaPeriod, 0,MODE_SMA,PRICE_CLOSE,0);
double zScore  = ( Bid - mean ) / sigma;
*/