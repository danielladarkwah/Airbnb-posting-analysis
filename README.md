# Airbnb-posting-analysis report 

# Executive Summary
This analysis aims to uncover patterns within Airbnb's text and numerical data to reveal insights into guest
satisfaction and potential avenues for enhancing the platform's offerings. Text mining techniques such as
tokenization, n-grams, sentiment analysis, and LDA were used to dissect listing descriptions to understand the
elements most valued by guests. Simultaneously, I conducted a numerical analysis examining correlations
between variables such as price, review scores, and property features. The key findings suggest that unique property
types like campers/RVs and boats yield high satisfaction ratings, indicating a market for distinctive lodging
experiences. Sentiment analysis highlighted regional differences in guests' perceptions, with positive language
usage correlating with higher satisfaction in certain countries. To leverage these insights, I recommend Airbnb
promote exceptional property experiences, encourage hosts to enhance amenity quality, and adopt tailored
marketing strategies that resonate with regional sentiments and lifestyle.

# Analysis and Findings
Text Mining Analysis Findings

Tokenization and N-grams Analysis
Our analysis utilized tokenization to deconstruct Airbnb listings into tokens, bigrams, and trigrams. The most common bigrams included phrases such as "walking distance" and "minutes walk," which highlight the guests' preference for properties located close to essential amenities and attractions. Trigrams such as "queen size bed" and "equipped kitchen" further revealed preferences for specific amenities and features within the property.

Sentiment Analysis
The sentiment analysis leveraging Bing and NRC lexicons reveals a strong prevalence of positive language in Airbnb listing descriptions, indicating that hosts typically present their listings in an optimistic tone to attract guests. Positive sentiments overwhelmingly outnumber negative ones, with the NRC lexicon registering a substantial sentiment score. This positive skew likely influences guests' expectations and perceptions, contributing to higher satisfaction and more favorable reviews. By recognizing the impact of emotional tone on guest experience, Airbnb can guide hosts in crafting compelling listings and implement targeted strategies to amplify satisfaction and loyalty.

Latent Dirichlet Allocation (LDA)
The LDA model identified dominant topics and terms within the listings. Keywords like "apartment," "city," "beach," and proximity-related terms indicated guests' inclinations towards certain types of properties and locations. The prominence of such terms suggests guests are keen on relaxation and luxury to enhance their lifestyle.

# Dashboard Created (Numerical Analysis Findings)

Correlation Insights
The correlation heatmap provides critical insights into the relationships between various aspects of Airbnb listings. The weak negative correlation between price and review scores suggests that higher prices do not necessarily equate to higher guest satisfaction. Conversely, a positive correlation between number of reviews and review scores indicates that listings with more reviews tend to have higher ratings, possibly reflecting a consistent quality experience that encourages guests to leave reviews.

Average Review Score by Property Type Insights
The high satisfaction rating for campers/RVs might reflect a niche but highly satisfied customer base. This could indicate that guests seeking unique experiences like RV camping are finding their expectations met, contributing to higher ratings. This is a valuable insight for Airbnb to consider in promoting unique stays.

Average Sentiment by Country Insights
The higher average sentiment score for the United States may reflect cultural differences in communication, with American listings potentially using more positively connoted language. This suggests that Airbnb hosts in the US might be more adept at crafting appealing descriptions, which could influence guest satisfaction.

Bigram Network Insights
The prominence of terms like "queen size bed" and "flat screen TV" within the bigram network suggests that guests prioritize comfort and modern amenities. The visualization indicates a trend towards preferring accommodations that promise a blend of comfort and convenience.

Average Sentiment per Property Type Insights
Boats scoring highly on sentiment analysis may reflect an association with luxury or adventure, qualities that resonate well with guests. This finding suggests a market for unique listings that offer more than just a place to stay, such as an experience or lifestyle.


# Business Insights and Recommendations 
Text mining analysis insights revealed the importance of specific amenities and location to guests. To capitalize on this, Airbnb should encourage hosts to highlight proximity to popular sites and availability of sought-after amenities like minute walks to popular sites like Rio De Janeiro in their listings. Furthermore, enhancing search algorithms to prioritize these key terms can improve the visibility of the most relevant listings to potential guests. It also indicated that the positive sentiment expressed in listings correlates with higher guest satisfaction. Hosts should be coached to use upbeat and welcoming language that performs well in sentiment scoring, particularly with lexicons like Bing. Airbnb could offer resources, such as listing optimization tools or writing workshops, to assist hosts in creating appealing descriptions that are likely to improve guest perception and engagement. There are distinct preferences for well-located properties with specific amenities. Airbnb can utilize the terms identified like equipped kitchen to guide hosts in incorporating language that aligns with guest interests. Highlighting these features in marketing materials and platform recommendations can also enhance the user experience. Airbnb can capitalize on the unique experiences market by promoting niche property types like campers/RVs and boats, which demonstrate high guest satisfaction. To enhance revenue, Airbnb could encourage hosts to focus on the quality of amenities and the allure of unique experiences, which are reflected in the common bigrams and high review scores. Given the correlation between the number of reviews and satisfaction, Airbnb might incentivize hosts to improve guest engagement, leading to more reviews and potentially higher ratings. Considering the importance of location and convenience, Airbnb could provide hosts with best practices for highlighting the central and convenient aspects of their properties. The higher sentiment scores in certain countries suggest that Airbnb could tailor its marketing strategies regionally, emphasizing the strengths observed in the sentiment analysis to attract more guests. The data suggests there is an opportunity for Airbnb to develop targeted promotional campaigns that highlight properties offering desired amenities like queen-size beds and flat-screen TVs, addressing the clear preferences identified in the bigram network analysis.
