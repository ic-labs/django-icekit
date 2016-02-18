Refactor of EventKit Repeating Events - Functional Spec
=======================================================

Document history:

* 2016-02-18 – jmurty : Initial draft, up to technical decision point described in Occurrence Implementation Options

## Goals

We need to simplify the way EventKit stores and manages repeating events.

Currently, repeating occurrences of events (including variations) are stored as full copies of the original event model. At best this means that all repeating events are based on a relatively heavyweight `PolymorphicMPTTModel` model, and at worst in cases like SFMOMA they are based on much richer models that include support for layouts, publishing, and other complex features.


## Concepts

### Event Series

An Event Series is a collection of events that are closely related, are all derived from a single original event, and should be treated as a whole.

An event series can be modelled as a tree structure, where modifications to a repeating event are descendants of the original event and repeating event occurrences may or may not be descendants.

### Event

An Event is a rich representation that stores the content and date range for one or more event occurrences in an event series. There are different kinds of events that serve different purposes, described in more detail in the sections below.

For terminology, an Event may be "one-time" or "repeating":

* a one-time event has no repeat rule, and is not really an event series. We aren't that interested in such events in this document.
* a repeating event has a repeat rule that generates a series of one or more occurrences. 
* an endless event is a repeating event with no end date, which goes on forever.

The key roles of a capital-E Event are:

* it stores the bulk of the content to display for an event occurrence
* it can be published [question E] (is not public by default)
* it provides an API to help manage its related events or occurrences.

### Original Event (Root)

The Original Event is the root event in a series, and is the first-created event from which all other items in the series are derived.

The Original Event is generally the first event in a series, though this is not guaranteed because:

* the first occurrence in a series may be cancelled/deleted or varied
* additional occurrences that take place before the original event might be added to an event series.

### Originating Event (Parent)

An Originating Event is an event from which other events in a series are directly derived.

The Original Event is also an Originating Event for any events/occurrences directly derived from that event in a series.

Aside for the Original Event, Variation Events are also originating events.

### Occurrence (Child?)

An Occurrence is a single instance of an event within an Event Series.

The main purpose of Occurrences is to serve as an in-database representation for each instance in an event series so we can quickly find and display future events, rather than needing to regenerate an entire event series to find information we need.

Only a limited number of future occurrences are ever generated and stored for an event series, to avoid trying to store every instance of potentially infinite event series in the database. This job is normally performed by a scheduled cron job, which generates occurrences up to a certain point in the future.

Currently all event occurrences are implemented as heavyweight copies of the original/originating event model, and are children of an originating event. The originating event is disjoint from its child occurrences.

We want to change and simplify this, so that:

* Occurrences can be represented by a much simpler model, with the bare minimum of fields and features necessary to represent future events in an Event Series
* Occurrences store only minimal content [question B] and defer to their originating event to store and render information about the event (other than the exact start/end dates & times)
* occurrences become easier to create and manage
* occurrences use fewer resources to store and retrieve from the DB

### Variation Event (Child)

A Variation event captures significant changes in a range of one or more events in an event series.

Creating a variation event causes a set of occurrences in the original event series to be deleted/ignored, and replaces them with a new set of occurrences with the varying times or content.

A Variation Event always has a related Originating Event, from which its initial content is cloned. The permitted date range for a variation event may also be constrained to be within the range of its originating event [question F]. A variation event may also have its own subordinate variations, for which it is the originating event [question G].

Common reasons for needing a variation are:

* if the usual start/end times of a repeating event need to vary for one or more occurrences
* if important content of the event is different, such as the title or other primary fields [question C]
* if one or more events in a series should be cancelled/deleted [question D]


## Occurrence Implementation Changes

To generate lightweight occurrences instead of event copies for each event in a series, we need to:

* define an Occurrence model, and relationship with Event
* modify the current Event model to generate Occurrences for repeating events instead of copying that event
* ensure the Occurrences generated to include one at the same time as the originating event, so we only ever need to query for occurrences not occurrences AND the originating event
* modify event views to find and display Occurrences instead of events, and to render the event content via the occurrence

## Occurrence Implementation Options

Aside from the broad changes outlined above to implement lightweight Occurrences, we need to choose between two possible approaches for generating, storing, and manipulating these occurrences.

We need to figure out which of these approaches we will pursue, or an alternate approach, before we can proceed much further.

### Occurrence Records are authoritative and permanent

With this approach Occurrence records are generated as-needed by an event, and once they are generated and stored in the database they will never be regenerated.

This approach is described in more detail in the Google Document "Eventkit architecture": https://docs.google.com/document/d/1aCGlLR1eYsR6MDrr0mx6jQytM-cHHURt37oMeS8dsWQ

Advantages - flexibility for user:

* our occurrence generator is relatively simple in the normal case
* user can manually move occurrences to adjust events rather than creating variations
* user can add arbitrary occurrences rather than extending an event's date range or creating a variation
* user can delete arbitrary occurrences rather than creating variation/exception events
* we could allow the user to tweak some occurrence content data, to make quick and minor alterations like override title or description of event occurrences.

Disadvantages - complexity for us:

* we need to track the date range for which occurrences were generated and never regenerate occurrences through that range
* muddies the conceptual waters between a repeating event as the source of an event series, versus ad-hoc occurrences altered in such a way that they make an event series
* unclear what we can/should do if user changes the start/end dates or repeat rules for an event? Do we: prevent that? create occurrences near & over existing ones? delete all existing occurrences?
* unclear what we can/should do if user applies a repeating variation to an event, where the variation date range overlaps with already-generated occurrences. And what if the user then removes that variation?
* it's an unusual approach that won't lend itself to exporting or exposing event data in the future in a standard formats such as iCal files.

### Event Series RRules are authoritative and Occurrence records are ephemeral

With this approach an Event has a relatively sophisticated Occurrence Generator that uses an Event's RRule representation of repeating events, along with the RRules for any subordinate Variation events, to generate Occurrences as-needed.

Occurrence records in the database are purely a cache of event series information, which can be generated or re-generated as-needed. The Occurrences themselves cannot be modified directly by a user, and can only be affected by modifying Event or Variation Event records to regenerate the desired event series.

This approach is partially implemented in the EventKit project branch *feature/937-prototype-rrule-as-truth* and described in the related SFMOMA ticket #937 and branch(es).

Advantages:

* no need to track which occurrences were generated
* follows the approach and workflow used by existing calendaring tools
* clearer implications for changing Event date ranges and adding/removing Variation Events: the regenerated occurrences will always correspond to what is in the Events
* could export/expose event data in a standard format like iCal in the future.

Disadvantages:

* must be able to store and execute sufficiently complex RRule specifications to generate all the kinds of event series and variations we want. The RRule spec in general, or the Python implementation in particular, may be too limiting
* user cannot make ad-hoc changes to directly add/move/delete occurrences, and must instead do so indirectly by adding/changing Event records
* much more difficult (infeasible?) to allow the user to make minor tweaks to occurrence to override event content, like title or description.


## Questions

* A: Can you create an event occurrence or variation that takes place before the original event?
* B: What content can vary and be stored in an occurrence? Any at all?
* C: What variations in event data require creation of a full Variation Event?
* D: Should event cancellations/deletions be represented by a Variation Event?
* E: Confirm that event changes, especially variations, do not apply to the public calendar until an event is published
* F: Is the date range of a variation event restricted to be within the range of its originating (parent) event?
* G: Do/should we permit nesting of variation events? I think we are better of not doing faking this, by cloning content from an originating variation event but actually keeping the event hierarchy flat so all an original event's variations are a single level below.

## TODO

* Template events
* Event cloning
* Admin interface implications