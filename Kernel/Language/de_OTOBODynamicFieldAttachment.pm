# --
# Copyright (C) 2001-2020 OTRS AG, https://otrs.com/
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (GPL). If you
# did not receive this file, see https://www.gnu.org/licenses/gpl-3.0.txt.
# --

package Kernel::Language::de_OTOBODynamicFieldAttachment;

use strict;
use warnings;
use utf8;

sub Data {
    my $Self = shift;

    # Template: AdminDynamicFieldAttachment
    $Self->{Translation}->{'Field'} = 'Feld';
    $Self->{Translation}->{'Maximum amount of attachments'} = 'Maximale Anzahl an Anhängen';
    $Self->{Translation}->{'Change this, if you need more or less attachments to be stored in this dynamic field.'} =
        'Ändern Sie diese Einstellung, wenn Sie mehr oder weniger Dokumente in dieses DynamicField speichern wollen.';
    $Self->{Translation}->{'Maximum attachment size'} = 'Maximale Dateigröße';
    $Self->{Translation}->{'Maximum size per attachment in MB for this dynamic field. 0 for no limit.'} =
        'Maximale Größe pro Anhang in MB für dieses DynamicField. 0 für keine Beschränkung.';

    # Perl Module: Kernel/Modules/AdminDynamicFieldAttachment.pm
    $Self->{Translation}->{'The maximum of attachments for this dynamic field of type attachment must be a positive number.'} =
        'Die maximale Anzahl der Anhänge muss eine positive Ganzzahl sein.';
    $Self->{Translation}->{'The maximum attachment size for this dynamic field of type attachment must be a positive number.'} =
        'Die maximale Größe jedes Anhangs muss eine positive Ganzzahl sein.';
    $Self->{Translation}->{'Need ValidID!'} = 'Benötige ValidID!';
    $Self->{Translation}->{'Could not create the new field.'} = 'Das neue Feld konnte nicht erstellt werden.';
    $Self->{Translation}->{'Need ID!'} = 'Benötige ID!';
    $Self->{Translation}->{'Could not get data for dynamic field %s!'} = 'Es konnten keine Daten für das dynamische Feld %s abgerufen werden!';
    $Self->{Translation}->{'Could not update the field %s!'} = 'Das Feld %s konnte nicht aktualisiert werden!';

    # Perl Module: Kernel/Modules/AjaxDynamicFieldAttachment.pm
    $Self->{Translation}->{'Success'} = 'Erfolg';

    # JS File: Core.Agent.DynamicField.Attachment
    $Self->{Translation}->{'Disable Attachments'} = 'Anhänge deaktivieren';

    # SysConfig
    $Self->{Translation}->{'Dynamic Fields Attachment Backend GUI'} = 'Backend-GUI für Anhänge dynamischer Felder';
    $Self->{Translation}->{'Dynamic Fields Attachment download frontend'} = 'Download-Frontend für Anhänge dynamischer Felder';
    $Self->{Translation}->{'Dynamic field backend registration.'} = 'Backend-Registrierung für dynamische Felder.';
    $Self->{Translation}->{'Dynamic fields extension.'} = 'Dynamische Felder Erweiterung.';
    $Self->{Translation}->{'Frontend module registration for the admin interface.'} = 'Frontend-Modulregistrierung für das Administrator-Interface.';


    push @{ $Self->{JavaScriptStrings} // [] }, (
    'Cancel',
    'Delete',
    'Disable',
    'Disable Attachments',
    );

}

1;
