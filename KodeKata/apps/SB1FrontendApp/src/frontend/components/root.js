import React from 'react';
import {Grid, GridCol, GridRow} from '@sb1/ffe-grid-react';
import { Input } from "@sb1/ffe-form-react";
import { ActionButton } from "@sb1/ffe-buttons-react";

class Root extends React.Component {
  render() {
    return (
      <Grid>
        <GridRow>

            <GridCol sm={{ cols: 6, offset: 3 }} md={{ cols: 4, offset: 4 }} lg={{ cols: 9, offset: 0 }}>
              <Input
                value={ '' }
                onChange={ () => {} }
                placeholder="Placeholder text"
                required
              />
            </GridCol>

            <GridCol sm={{ cols: 6, offset: 3 }} md={{ cols: 4, offset: 4 }} lg={{ cols: 3, offset: 0 }}>
              <ActionButton
                isLoading={ false }
                onClick={ f => f }
                ariaLoadingMessage="Vennligst vent..."
              >Action-knapp
              </ActionButton>
            </GridCol>

        </GridRow>
      </Grid>
    );
  }
}

export default Root;
