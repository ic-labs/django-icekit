Refactor of ICEKit Events' Repeating Events - Functional Spec
=============================================================

Document history:

* 2016-03-08 - jmurty : Revised draft following feedback from Greg in https://github.com/ixc/icekit-events/pull/9/files#r54678289
* 2016-03-01 - jmurty : Revised draft following discussions with Greg and Tai and comments in https://github.com/ixc/icekit-events/pull/9/files
* 2016-02-18 – jmurty : Initial draft, up to technical decision point described in Occurrence Implementation Options

## Goals

We need to simplify the way ICEKit Events stores and manages repeating events.

Currently, repeating occurrences of events (including variations) are stored as full copies of the original event model. At best this means that all repeating events are based on a relatively heavyweight `PolymorphicMPTTModel` model, and at worst in cases like SFMOMA they are based on much richer models that include support for layouts, publishing, and other complex features.


## Concepts and Models

### Event Family

An Event Family is a collection of events that are closely related, are all derived from a single original event, and which should be treated as a whole in the system.

Currently – before the changes recommended in this document are applied – event families are modelled as a tree structure comprising originating events at the root, and repeating/variation events as descendants. All these event types are derived from the same base model, and the tree structure is exposed and managed by [django-mptt].

We will simplify this significantly such that an event family will comprise:

* a single Event object to store descriptive content, and *optional* time & repeat definitions
* a set of zero or more Occurrence items to represent times the event takes place.

There will no longer be a tree structure beyond a loose "derived from" relationship that we will store internally and
which will not affect event logic. The relationship will only be exposed to users in a limited non-editable way, perhaps
as in the admin as a read-only link to go and edit the derived-from object.

MPTT tree management utilities will no longer be required, so we can remove even more complexity from the Event model.

### Event

An Event stores the descriptive content of an event and provides features for managing the event and any related items in the event family.

Currently an Event includes a great deal of information and functionality, much of which we will remove:

* descriptive content about the event for display to website visitors (e.g. title, description, image assets, location, etc etc)
* it is publishable
* a required start date/time, to represent the time this particular event occurs
* optional repeat rule and end date/time fields, to define the frequency and boundary of subordinate repeating events that will be generated from this event
* information about the event's location in a tree structure, used to impose constraints on the behaviour and functionality of an event based on its role within an event family
* a complex type classification based on how the event was created, its relationship with other events in an event family tree structure, and how it is intended to be used. In this type classification, an Event may be one or more of:

  * "original" or "root" event: the root event in an event family, the first one created from which all other events in the family are derived
  * "originating" or "parent" event: an event from which other child event items are derived
  * "repeated" event: an event that represents a single occurrence in a repeating event family, where all the event's contents are copied from the originating/parent event
  * "variation" event: an event cloned from an existing event in order to modify its content, occurrence start date/time, or repeat rule to alter a subset of occurrences within an event family.

We will simplify this such that an event will comprise only:

* descriptive content about the event for display to website visitors (e.g. title, description, image assets, location, etc etc)
* it is publishable
* *optional* start date/time, repeat rule and end date/time fields, to define the frequency and boundary of repeating Occurrences that will be generated for this event
* a related set of zero or Occurrence items that store times the event occurs and should be displayed on a calendar. An Event may have zero occurrences, in which case it will not be displayed on a calendar.
* if the event was cloned from another one, a loose (nullable) relationship back to the original event. This information will be merely stored for now; it will not be exposed to the user and will not imply any particular behaviour or usage of the cloned or original events.

The key changes are:

* the date/times when an event occurs are no longer stored within Events, but within Occurrences instead. And the occurrence date/times are not necessarily derived from times set in the event, they may be eanually created or generated by repeat rules.
* the start date/time that was required becomes optional, and will only be needed as part of a repeat rule definition
* we remove all the tree structure mechanisms and restrictions, including expunging MPTT entirely
* the only remaining intra-event relationship is the new "cloned-from" field, which is for record-keeping only

Longer term, we may further adapt Event to:

* support multiple repeat rules, e.g.to easily model an event that happens at 11am and 2pm, Mondays and Thursdays.
* relocate the repeat rules features to become part of Glamkit+, so might be worth factoring out at this time, even though it isn't MVP.


#### Repeating Event

A repeating event is one which has a repeating rule which defines the start date/time, frequency, and (optionally) end date/time of a series of times when the event should be shown on a calendar. If an end date/time is not set on a repeating event it will continue occurring forever.

Currently, when an Event has a repeating rule defined it generates a set of clones of itself, where each clone has its start date/time set to the time of an occurrence in the series. This series of event objects are the children of the "originating" event that defined the repeat rule, and when they are displayed to visitors all the content is drawn from that originating event.

Instead of event clone children we will instead use lightweight Occurrence objects to represent times when an event should be shown on a calendar. An event will manage repeating occurrences by:

* when a repeat rule is defined on an event, it will automatically generate a series of Occurrences via its internal RRule to represent the times the event should appear on a calendar, up to a sensible end date/time boundary (i.e. not forever for endless repeating events, or too far ahead for repeating events with far-future end date/times)
* generating additional occurrences further into the future as-needed, e.g. when triggered to extend the range of repeating occurrences by a scheduled job
* if a repeat rule is removed, any existing automatically-generated (but not user-modified) occurrences are deleted
* if a repeat rule is changed, any existing automatically-generated  (but not user-modified) occurrences are deleted then the new occurrences are created
* the event is aware of occurrences that have been created or modified by the user: it never deletes or alters these occurrences
* the event is aware of occurrences that have had their date/time modified by the user from their original auto-generated date/time: it will avoid auto-generating new occurrences with date/times that match either the original or the updated date/time.

### Occurrence

An Occurrence is a new light-weight representation we will use in ICEKit Events to store the date/time and duration when an Event should be shown on a calendar. In particular, it replaces the need to clone whole Event models just to change their date/time as is currently the case.

The main purpose of Occurrences is to serve as an in-database representation for each instance in an event family so we can quickly find and display future events, rather than needing to regenerate an entire event family to find information we need. To be absolutely clear, events will only appear in a calendar if they have at least one occurrence – an event with no occurrences is invisible in a calendar.

Aside from the time information, occurrences will store some additional information the Event will need to properly manage its occurrences.

Occurrences have the following properties:

* the date/time and duration to occupy on a calendar
* the Event that "owns" the occurrence, from which the vast bulk of content to display to visitors is drawn
  * NOTE: if/when Repeat Rule is factored out so that one event can have many repeat rules, this becomes a nullable FK to the rule that generated it.
* a "status" field to capture other one-time information about an occurrence, e.g. Cancelled, Excluded, Sold-out, etc.
* an "is_generated" flag, set when an occurrence is automatically generated by an Event as one of a repeating series
* an "is_user_modified" flag, set when an occurrence is:

  * created directly by a user in the admin interface
  * modified by a user to have a different date/time or duration
  * modified by a user to have a different status
* hidden **original** date/time and duration fields, set when a user adjusts the date/time or duration of an occurrence.

See in Repeating Event above how these flags and fields are used to (re)generate occurrences. Note that an occurrence may be flagged as both "is_generated" and "is_user_modified" if it was auto-generated initially, then modified by a user. Note also  that a user can create occurrences at arbitrary date/times, there are no restrictions based on the repeat rule an event might have.

Regarding the "status" field, we may need both "Cancelled" and "Excluded" statuses to differentiate between occurrences that have been cancelled and should be displayed as such on a calendar ("Cancelled"), versus occurrences that have been cancelled but should not be displayed ("Excluded"). The "Excluded" status will be needed, in addition to the ability to actually delete the occurrence record from the DB, for cases where the user wants to delete/hide an occurrence that was initially auto-generated and prevent the Event from ever regenerating it.


## Administration

### Admin UI

The model changes in this spec will require numerous admin changes for ICEKit Events:

* the calendar on the event listing page will show only occurrences
* the event list on the event listing page will include all events, whether or not they have occurrences
* display an event's occurrences on its admin detail page, probably as an inline set
  * occurrences should be displayed differently based on their status. In particular, Excluded occurrences need to be visually distinct
    enough to be able to tell during a scroll - either transparent, shaded red, or grouped in another part of the page.
* user can add/delete/modify occurrences on an event's detail page
* user adjustments permitted: adjust date/time, adjust duration, set status flag to "Cancelled" etc
* PUBLISHING: draft/published status shown on an event, and availability of Publish button, is based on both the Event itself and any user modifications made to its occurrences. For example, if a user adds an occurrence it makes the draft event newer than the published one, so the publish status description should reflect this and the Publish button be made available.
* FUTURE: user can clone an event

### Publishing (SFMOMA)

Events are publishable in SFMOMA, and likely will also be so in future projects even though ICEKit Events itself has no publishing features. As such, we need to understand how publishing will interact with events.

A publishable event:

* is not visible to the public directly until it is published
* its occurrences are not visible to the public until the event is published
* user modifications to an event's occurrences are not publicly visible until the event is published
* changes to an event's generated occurrences, such as by changing a repeat rule, are not publicly visible until published

BUT to keep published events up-to-date, we will need some special handling:

* the scheduled job that extends the occurrences for a repeating event applies to both draft and published copies of events, so that future occurrences are generated to populate the publicly-visible calendar.

Note also that Events in SFMOMA have a `show_in_calendar` boolean flag, which, when cleared, excludes the event from showing in calendars and search listings, and in future on the googles. Thus an event may be published but still not be fully visible to the public, or indeed visible at all, depending on custom logic like this.

### Event Cloning (NEAR FUTURE)

Events will be cloneable in the system, such that an event's content and settings can be easily copied into a new event where it can be adjusted and repurposed by admins.

When an event is cloned, we set the "cloned-from" field of the event copy to point back to the original event as a loose nullable relationship. This relationships will be for bookkeeping purposes only for now. It will not be exposed in the site admin, and will not imply any particular behaviour or restrictions for either side of the relationship.

The cloning feature combined with direct user modifications of occurrences will enable informal but powerful management workflows for admins.

#### Event Prototypes

Any Event can act as a prototype for the creation of similar events, which can be cloned then adjusted from the original event:

* user creates an event with commonly re-used content, and does not set a repeat rule or publish the event
* user gives the event an obvious name, like "[Prototype] Museum Open Days"
* user can then clone this "prototype" event as a starting-point for concrete events, adjust the title and slug, assign repeat rules and/or additional ad-hoc occurrences to the copy, and publish the result.

#### Event Variation

Any Event can be cloned and adjusted to make slight, or even major, variations to the event:

* use clones an existing event to a copy, then adjusts its content and/or repeat rule
* user must also set a unique slug value for the cloned event
* user assigns a repeat rule and/or adds ad-hoc occurrences
* user deletes any clashing/duplicate occurrences from the original event
* user publishes the cloned variation event

NOTE: Longer-term, the admin could include features to automate replacing one or more occurrences with a variation event, to make this easier. For now, however, it's okay for this to be an entirely manual process.


[django-mptt]: https://github.com/django-mptt/django-mptt
